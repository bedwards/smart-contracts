c.Minted().watch(function(error, result) {
  if (error) {
    console.log('Minted error');
    console.log(JSON.stringify(error, null, 2));
  }
  if (result) {
    console.log('Minted result');
    console.log(JSON.stringify(result, null, 2));
  }
});

c.Sent().watch(function(error, result) {
  if (error) {
    console.log('Sent error');
    console.log(JSON.stringify(error, null, 2));
  }
  if (result) {
    console.log('Sent result');
    console.log(JSON.stringify(result, null, 2));
    console.log("from's balance: " + c.balances(result.args.from));
    console.log("to's balance: " + c.balances(result.args.to));
  }
});

c.mint(c.minter(), 85);
var other = personal.newAccount('');
c.send(other, 42);
