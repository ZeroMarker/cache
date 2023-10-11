/**
 * @author Administrator
 */
/*
I have defined two div's in a html file: 

The last one just for debug and testing purpose.
*/

	// Defining the fields for the record.
	var fields = [ {name: 'timestamp', type: 'date'}, 'temperature'];

	// Sets up the record
	var rec = new Ext.data.Record.create([
        { name: 'datetime', type: 'date', dateFormat: 'Y-m-d H:i:s'},
        { name: 'temp' }
    ]);

	// Creates an array with the data
	var data = [
	    ['2009-08-22 00:00:00', 10],
	    ['2009-08-22 01:00:00', 10.2],
	    ['2009-08-22 02:00:00', 10.6],
	    ['2009-08-22 03:00:00', 10.7],
	    ['2009-08-22 04:00:00', 10.8],
	    ['2009-08-22 05:00:00', 10.6],
	    ['2009-08-22 06:00:00', 10.9],
	    ['2009-08-22 09:00:00', 10.6],
	    ['2009-08-22 12:00:00', 11.2],
	    ['2009-08-22 15:00:00', 11.5],
	    ['2009-08-22 18:00:00', 11.7],
	    ['2009-08-22 21:00:00', 11.9]
    ];

	// Creates an array reader
	var reader = new Ext.data.ArrayReader({}, rec);

	// And finally the store
	var store = new Ext.data.Store({
		fields: fields,
		reader: reader,
		data  : data
	});
var grid = new Ext.grid.GridPanel({
	store: store,
	columns: [
         	{header:'datetime', renderer: function(date) { return date.format("d. H"); }},
         	{header: 'temp'}
     	],
	renderTo: "grid",
	autoHeight: true
});

