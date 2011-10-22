# FoodInfo

FoodInfo is a ruby gem that retrieves food nutrition information from various online data sources.



## Installation

FoodInfo is available as a gem, so installation is as simple as:

    gem install food_info



## Supported Data Sources

There's currently only one adapter implemented, which pulls data from [FatSecret's REST API](http://platform.fatsecret.com/api/Default.aspx?screen=rapih).  The code's modular and adding additional data sources should be fairly straightforward, but since DailyBurn discontinued their API access I don't know of any other solid sources (if you do, though, please let me know and/or add an adapter!).



## Usage

### Housekeeping

To use the FatSecret API (currently your only option), you'll first need to [sign up for a free developer account](http://platform.fatsecret.com/api/Default.aspx?screen=r) and retrieve the "REST API Consumer Key" and "REST API Consumer Secret" from your "My Account" tab.

Once that's done, the first step is to tell FoodInfo which adapter you want to use and what authorization to send.

    FoodInfo.establish_connection(:fat_secret, :key => 'YOUR-KEY', :secret => 'YOUR-KEY')


### Caching

To cache results, FoodInfo supports passing in an instance of a memcache-API-compatible (i.e. responds to <code>get</code> and <code>set</code>) caching object.  I recommend using the [Dalli gem](https://github.com/mperham/dalli).

    require 'dalli'
    client = Dalli::Client.new('localhost:11211')
    FoodInfo.establish_connection(:fat_secret, :key => 'YOUR-KEY', :secret => 'YOUR-KEY', :cache => client)

With that in place repeated <code>search</code> or <code>detail</code> requests will pull from the cache, and not the API endpoint.

### Searching

Now we can search for foods.

    cheese = FoodInfo.search('cheese')
    cheese.total_results    # => 2469
    cheese.per_page         # => 20
    cheese.page             # => 1
    cheese.results          # => ... big array ...
    cheese.results.first    # => 
    # {
    #     "description" => "Per 100g - Calories: 403kcal | Fat: 33.14g | Carbs: 1.28g | Protein: 24.90g",
    #              "id" => "33689",
    #            "kind" => "Generic",
    #            "name" => "Cheddar Cheese",
    #             "url" => "http://www.fatsecret.com/calories-nutrition/usda/cheddar-cheese"
    # }

(As an aside, I get that pretty, nicely-lined-up console formatting from the remarkably awesome [AwesomePrint Gem](https://github.com/michaeldv/awesome_print)).

#### Pagination

Search supports pagination via the <tt>page</tt> and <tt>per_page</tt> (max 50) parameters:

    FoodInfo.search('cheese', :page => 2, :per_page => 50)

#### Access to search results

You can access the results of the search explicitly:

    FoodInfo.search('cheese').results # => ... lots of results ...

But the SearchResults class includes Enumerable, so you can also just call enumerable methods on it directly:

    FoodInfo.search('cheese').map(&:name) # => array of names of matching foods
    

### Nutritional Details

Once you have a specific food item in mind from the search results, you can retrieve a whole lot of additional information.

    cheddar = FoodInfo.search('cheese').first
    info = FoodInfo.details( cheddar.id ) # => ... a whole lotta data ...

General metadata about the cheese includes id, name, kind, and url, which are identical to what you'd get from the <tt>search</tt> method.  It also has one or more servings, however, and this is where we finally get our nutrition info.

    serving = info.servings.first # =>
    # {
    #                     "calcium" => 95,
    #                    "calories" => 532.0,
    #                "carbohydrate" => 1.69,
    #                 "cholesterol" => 139.0,
    #                         "fat" => 43.74,
    #                       "fiber" => 0.0,
    #                          "id" => "29131",
    #                        "iron" => 5,
    #     "measurement_description" => "cup, diced",
    #       "metric_serving_amount" => 132.0,
    #         "metric_serving_unit" => "g",
    #         "monounsaturated_fat" => 12.396,
    #             "number_of_units" => 1.0,
    #         "polyunsaturated_fat" => 1.243,
    #                   "potassium" => 129.0,
    #                     "protein" => 32.87,
    #               "saturated_fat" => 27.841,
    #         "serving_description" => "1 cup diced",
    #                      "sodium" => 820.0,
    #                       "sugar" => 0.69,
    #                   "trans_fat" => 0.0,
    #                         "url" => "http://www.fatsecret.com/calories-nutrition/usda/cheddar-cheese?portionid=29131&portionamount=1.000",
    #                   "vitamin_a" => 26,
    #                   "vitamin_c" => 0
    # }
    
For full details on what each of those fields contains, check [the FatSecret documentation](http://platform.fatsecret.com/api/Default.aspx?screen=rapiref&method=food.get#methodResponse).


## Legal Note

The FatSecret TOS requires you not to store, well, [pretty much anything](http://platform.fatsecret.com/api/Default.aspx?screen=rapisd) aside from food or serving IDs for more than 24 hours.  This is annoying, but I figured I'd give you a heads up.


## Note on Patches/Pull Requests

Contributions are welcome, particularly adding adapters for additional data sources.

As always, the process is to fork this project on Github, make your changes (preferably in a topic branch, and without changing the gem version), send a pull request, and then receive much appreciation!

## License

Copyright &copy; 2011 [Deviantech, Inc.](http://www.deviantech.com) and released under the MIT license.

