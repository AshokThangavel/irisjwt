Class irisjwt.JWT Extends %RegisteredObject
{

/// Generate Symmetric signed JWT
ClassMethod Encode(pPayload As %DynamicObject = {{}}, pSecret As %String = "", pAlgorithm As %String = "HS256", pJWTHeader As %DynamicObject = {{}}) As %String
{
	Try{
		Do ..BuildHeader(pAlgorithm,pJWTHeader)
		If '$IsObject(pPayload)&&(pPayload'="") Set pPayload= {}.%FromJSON(pPayload)
	    Do ..CreateJWKS(pAlgorithm, pSecret,.jwks)
	    $$$ThrowOnError(##Class(%Net.JSON.JWT).Create(pJWTHeader, , pPayload, $Get(jwks), , .JWT))
	}
	Catch ex {
		Set %jwterror = $SYSTEM.Status.GetErrorText(ex.AsStatus())
        Set JWT = ""
	}
    Quit JWT
}

/// Generate the payload from JWT token
ClassMethod Decode(pToken As %String = "", pSecret As %String = "", pAlgorithm As %String = "HS256") As %DynamicObject
{
	Try {
		Do ..CreateJWKS(pAlgorithm, pSecret,.jwks)
		$$$ThrowOnError(##Class(%Net.JSON.JWT).Validate(pToken, jwks, ,,.claims,.op))
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

ClassMethod BuildHeader(pAlgorithm As %String = "HS256", jwtHeader)
{
	If '$IsObject(jwtHeader) {
		Set jwtHeader = {"alg": (pAlgorithm), "typ": "JWT"}
	}
	Else {
		Set:'jwtHeader.%IsDefined("alg") jwtHeader.alg=pAlgorithm
		Set:'jwtHeader.%IsDefined("typ") jwtHeader.typ="JWT"
	}
}

ClassMethod ListToDA(pList As %List) As %DynamicArray [ Internal, Private ]
{
    Set DA = []
    Set ptr = 0
    While $listNext(pList,ptr,val) {
		Do DA.%Push(val)
	}
    Return DA
}

ClassMethod CreateJWK(pAlgorithm As %String, pSecret As %String, Output privateJWK As %Net.JSON.JWK, Output publicJWK As %Net.JSON.JWK) [ Internal, Private,CodeMode = expression]
{
##Class(%Net.JSON.JWK).Create(pAlgorithm, pSecret, .privateJWK, .publicJWK)
}

ClassMethod CreateJWKS(pAlgorithm As %String, pSecret As %String, JWKS) [ Internal, Private ]
{
   $$$ThrowOnError(..CreateJWK(pAlgorithm, pSecret, .privateJWK, .publicJWK))
   $$$ThrowOnError(##class(%Net.JSON.JWKS).PutJWK(privateJWK,.JWKS))
}

}
