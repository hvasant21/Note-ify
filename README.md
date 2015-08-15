# Note-ify
An iPhone app using Dropbox Core SDK to sync files to dropbox account. Supports offline functionality.

## Modules
The modules present are:

# UI
- NotesViewController & NotesEditViewController : UI element to construct the basic user interface.
- NotesViewModel : Contains the business logic and method implementations to cater the requirement of viewcontroller. Acts as an intermediate layer between view and manager.

# Manager
- DropBoxManager : Holds the dropbox API to create/update and delete file.
- DropBoxSessionManager : Holds the API to instatiate and manage dropbox session

# API
- NotesAPI : Notes API contains functions which communicates to DB and Server to fetch data. Maintains business logic ,to determine when the server call has to be triggered. Fetches data from DB in the absense of internet.

# Model
- DataModel : Data Model file for the data store.
- Entities : NSManagedObject entities.
- Transfer Object : Object used to transfer data to UI layer.
- Wrapper : Category on core data entities to perform manipulation (add/delete/update) entities and return transfer object to UI layer.

#Frameworks used
- DropboxSDK
- Magical Record
- CoreData


