## Next Steps

Upon completion, briefly outline the next few steps you would plan to take to complete the entire feature spec.

* Add

Searching is something that can get complicated really quickly. I added a very basic implementation for the search feature
using SQL queries but to get a more robust and extensible solution I would create an elasticsearch index to provide full-text
search capabilities.

I would also add more model validations to make sure the data is consistent and real.

Error handling is also something that would make the forms more user-friendly.

* Polish
Business logic in the controller is usually a code-smell so I'd like to move everything out of there and implement
service or query objects to keep the business logic reusable, isolated and agnostic to the API.

The views could also get messy quickly so I'd start using some presenters or view components to keep the presentation
logic where it should be.

* Tests

I'd split the existing feature test into smaller tests and I would add more tests to every layer of the application,
starting with model tests for validations and associations.

## Bugs and Issues

Did you run into any issues with the existing system, or notice any bugs.

* bug/issue #1
  Probably not a bug but the description in the social network model needed a restriction to have a known list
  of possibilities to search.

* bug/issue #2
  There is no displaying of errors upon submit for the content items.

## Thoughts and Comments

Very interesting test. I hadn't used the calendar gem before, it was pretty straightforward to integrate.
