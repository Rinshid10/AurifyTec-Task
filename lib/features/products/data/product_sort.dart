//  <--------- Product Sort Enum --------->
//* TO list the server-side sort options supported by DummyJSON
enum ProductSort {
  relevance('Recommended', null, null),
  priceLowHigh('Price: low to high', 'price', 'asc'),
  priceHighLow('Price: high to low', 'price', 'desc'),
  topRated('Top rated', 'rating', 'desc'),
  biggestDiscount('Biggest discount', 'discountPercentage', 'desc');

  const ProductSort(this.label, this.sortBy, this.order);

  //  <--------- Fields --------->
  //* TO hold the display label plus the sortBy and order query values where null means no sort
  final String label;

  final String? sortBy;
  final String? order;
}
