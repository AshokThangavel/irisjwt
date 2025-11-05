# irisJWT

`irisJWT` is an ObjectScript library for **JWT (JSON Web Token) encoding and decoding** in InterSystems IRIS. It supports both symmetric (HMAC) algorithms and allows optional custom headers.

## Features

- Encode payloads into JWTs
- Decode and verify JWTs
- Optional custom headers
- Symmetric (HS256) support by default
- Compatible with IRIS 2024.1+ (uses latest classes)

## Future Implementation

- **Asymmetric JWT Support (RSA / EC)**
  
## Installation

### 1️⃣ Install via ZPM (InterSystems Package Manager)

```objectscript
ZPM> INSTALL irisJWT
```

## ⚙️ Installation

### Clone the Repository
```bash
git clone https://github.com/AshokThangavel/irisjwt.git
cd irisjwt
````

### Running the Application with Docker

Build and start the app using Docker Compose:

```bash
docker-compose up --build
```

### Stopping the Application

To stop and remove the running containers:

```bash
docker-compose down
```
### Usage
```objectscript
Set token = ##class(irisjwt.JWT).Encode(payloadDAObject, secret, algorithm, headerDAOject) ; returns JWT token
Set payload =  ##class(irisjwt.JWT).Encode(token, secret, algorithm) ; retuns %DynamicObject
Set supportedAlog =  ##class(irisjwt.JWT).SupportedAlgorithms() ; returns supported alogrithms
```
The `Encode` and `Decode` methods return the JWT string or decoded payload on success.  If an error occurs, they return an empty string (`""`).  
You can check the following variables for details:
- `%jwterror` → Contains the exact error message.  
- `%objlasterror` → Contains detailed error information for debugging.

## Contrbution
👉 Check out our [Contributing Guidelines](./CONTRIBUTING.md) for more details.
