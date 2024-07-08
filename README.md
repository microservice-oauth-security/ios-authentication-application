# Details

This project creates an iOS Authentication Application which has an Authentication screen with Login, Sign-In and Sign-In with Google option.  
Once the user authenticates successfully from the authentication screen, user will be navigated to Home screen, where the user has an option to call a micro-service using the authentication token generated from the authentication screen.

# Points to Note
1. #### Google OAuth iOS Client Id
   Change the value of **$(GIDClientID)** and **$(REVERSED_GIDClientID)** in the file *AuthApplication/Info.plist*, with the google iOS client id and reversed iOS client id from your Google OAuth consent screen project.

2. #### Backend Service Url
   Change the value of urls defined in the file *AuthApplication/dev.xcconfig*, with the url of your backend service.  
   You can create your backend service from the below repo.  
   [Authorization Application](https://github.com/microservice-oauth-security/authorization-application)  
   [User Authentication Service](https://github.com/microservice-oauth-security/user-authentication-service)  
   [Demo Microservice](https://github.com/microservice-oauth-security/demo-microservice)


# Video Reference
For detailed video explanation of this project please visit my YouTube channel [CodeWithAnish](https://www.youtube.com/@CodeWithAnish)
