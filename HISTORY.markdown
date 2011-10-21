# Changelog

## 0.0.6 October 21, 2011
* FatSecret: Retry once if timestamp invalid (API only supports single request/second)

## 0.0.5 September 26, 2011
* Bugfix: missing 'return' was wreaking havoc with FoodInfo.search

## 0.0.4 September 26, 2011
* API improvement: Can index directly into search results (e.g. FoodInfo.search('a')[3])
* Bugfix: FoodInfo.details('..') now correctly handles results with only one serving returned

## 0.0.3 September 12, 2011
* Added missing gem dependency on ruby-hmac

## 0.0.2 September 11, 2011
* Added propagation of errors from data source
* API improvement: No need to call <tt>results</tt> on FoodItem.search to access search results

## 0.0.1  September 10, 2011
* Initial release. FatSecret adapter supports both <tt>search</tt> and <tt>details</tt> methods.