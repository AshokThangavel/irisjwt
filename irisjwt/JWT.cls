Class irisjwt.JWT Extends %RegisteredObject
{

/// Generate Symmetric signed JWT
ClassMethod Encode(payload As %DynamicObject = {{}}, secret As %String = "secret", algorithm As %String = "HS256", jwtHeader As %DynamicObject = {{}}) As %String
{
	Try{
		Do ..BuildHeader(algorithm,jwtHeader)
		If '$IsObject(payload)&&(payload'="") Set payload= {}.%FromJSON(payload)
	    Do ..CreateJWKS(algorithm, secret,.jwks)
	    $$$ThrowOnError(##Class(%Net.JSON.JWT).Create(jwtHeader, , payload, $Get(jwks), , .JWT))
	}
	Catch ex {
		Set %jwterror = $SYSTEM.Status.GetErrorText(ex.AsStatus())
        Set JWT = ""
	}
    Quit JWT
}

/// Generate the payload from JWT token
ClassMethod Decode(token As %String = "", secret As %String = "", algorithm As %String = "HS256") As %DynamicObject
{
	Try {
		Do ..CreateJWKS(algorithm, secret,.jwks)
		$$$ThrowOnError(##Class(%Net.JSON.JWT).Validate(token, jwks, ,,.claims,.op))
	}
	Catch ex {
		Set %jwterror = $SYSTEM.Status.GetErrorText(ex.AsStatus())
        Set claims = ""
	}
    Return claims
}

ClassMethod SupportedAlgorithms() As %DynamicObject [ CodeMode = expression ]
{
{
"signatureAlgorithms":(..ListToDA(##class(%Net.JSON.JWA).#SignatureAlgorithms)),
"encryptionAlgorithms":(..ListToDA(##class(%Net.JSON.JWA).#EncryptionAlgorithms)),
"keyAlgorithms":(..ListToDA(##class(%Net.JSON.JWA).#KeyAlgorithms))
}
}

ClassMethod BuildHeader(algorithm As %String = "HS256", jwtHeader)
{
	If '$IsObject(jwtHeader) {
		Set jwtHeader = {"alg": (algorithm), "typ": "JWT"}
	}
	Else {
		Set:'jwtHeader.%IsDefined("alg") jwtHeader.alg=algorithm
		Set:'jwtHeader.%IsDefined("typ") jwtHeader.typ="JWT"
	}
}

ClassMethod ListToDA(List As %List) As %DynamicArray [ Internal, Private ]
{
    Set DA = []
    Set ptr = 0
    While $listNext(List,ptr,val) {
		Do DA.%Push(val)
	}
    Return DA
}

ClassMethod CreateJWK(algorithm As %String, secret As %String, Output privateJWK As %Net.JSON.JWK, Output publicJWK As %Net.JSON.JWK) [ Internal, Private ]
{
    Return ##Class(%Net.JSON.JWK).Create(algorithm, secret, .privateJWK, .publicJWK)
}

ClassMethod CreateJWKS(algorithm As %String, secret As %String, JWKS) [ Internal, Private ]
{
   $$$ThrowOnError(..CreateJWK(algorithm, secret, .privateJWK, .publicJWK))
   $$$ThrowOnError(##class(%Net.JSON.JWKS).PutJWK(privateJWK,.JWKS))
}

}
