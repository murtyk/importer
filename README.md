## Generic design for importing/uploading data into Ruby on Rails app.

### Design Goals/Assumptions:

1. Data file will be an excel file
2. Can handle large files
3. Will not incur request timeouts
4. Will show import progress status:  X rows succeeded and Y failed
5. Will display summary information on completion
6. Summary information will show error information for each failed row
7. Finally, the design should allow us to implement import into any model(table in db) with minimal effort.

So, how do we design this?

Well, lets start with some simple steps:

1. Processing the file synchronously can result in a request timeout if the file is large enough. Therefore we should process the file asynchronously and keep the user updated using ajax status requests. This means we need some background task manager and we will use Delayed Job for this.

2. We will have a class called Importer that does heavy lifting with common processing needs such as reading from excel file, processing each row, storing failed row data and corresponding error information etc.

3. For each model that needs import functionality, we will have a ModelImporter subclassed from Imporer. This will implement model specific logic.

So far we talked about M part of the MVC pattern. Lets describe V and C briefly.

view:

1. Navbar: One menu item for each model.

2. Importer New: File selection template.

2. Importer Create:
  1. One common template for showing the processing status. Make ajax requests for status enquiry.
  2. There will be one template for each model to show the results summary.

Controller: The controller should have minimal responsibility.

1. Simply instantiates an importer object and queues it for processing.
2. Handles status query request


OK, too much talk. Lets start the development.

Add gems to Gemfile:

1. delayed_job_active_record:  for delayed job background processing
2. roo: for reading excel file
3. rspec-rails: for specs

## Design the classes:

**FileStorage:** Stores the uploaded file. Import background process will read from it.

<a href= "https://github.com/murtyk/importer/blob/master/lib/importer/file_reader.rb"> FileReader</a> An abstract class for reading file data

<a href= "https://github.com/murtyk/importer/blob/master/lib/importer/excel_reader.rb"> ExcelReader</a> Subclassed from FileReader to read rows from excel file

<a href= "https://github.com/murtyk/importer/blob/master/lib/importer/importer.rb"> Importer</a>
For import process

<a href="https://github.com/murtyk/importer/blob/master/app/models/import_status.rb">ImportStatus</a>ActiveRecord based. For persisting all the relevant info of the import function including running status

**ImportersController:** Handles New and Create requests

**ImportStatusesController:** Handles status requests.

With the above design in place, you can easily implement import of data into any specific model(s).

Lets say you have Category model in your app and want to import some categories data.

Here are the steps to import categories:

1. Add menu item: ````<li><a href="/importers/new?model=category">Categories</a></li>````
2. Create a new class CategoryImportStatus < ImportStatus
3. Create CategoryImporter < Importer and implement required_attrs and import_row methods

If you want to customize the final status view template:

1. create show_categories.html.erb
2. Implement show_template method in CategoryImportStatus

Thats it.
