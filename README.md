# lufthansa_technical_assessment
Technical Assessment for iOS Software Engineers in Pilot Apps Team

Architecture: I decided to use MVVM because it seems to me to be the most complete, although for such small projects MVC could be used without problems. For much larger projects I would probably use VIPER.

Key classes: after all, the key classes in this type of architecture are the ViewModels.
On the one hand we have the LoginViewModel: it is in charge of the entire registration process as well as the validation of the fields and the treatment of the data.
On the other hand we have the ConfirmationViewModel: it is in charge of collecting the planes available for a certain license and deleting all the data when logging out.

Tests: I did a little of basic testing with unitTest, it can be improved testing more specific things about json data or the Keychain data, probably could use a library as KeychainAccess to make it easier. I had not enough time to implement any UI Test, anyways I think I worked too little with them to do a good job.

I tested some basic things with iPad and iPhone running the app in landscape and portrait, seems everything fine.

In LoginView in registerButtonTapped I commented some hardcode to test it faster, just needs to select a license.
