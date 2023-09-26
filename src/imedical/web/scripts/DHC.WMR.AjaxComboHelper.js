//For ComboBox
//Data Store and initiate 

//Create
function CreateComboDataStore(dataUrl,DicName,arg)
{
	var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '../csp/wuqksearch.csp'
        }),
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            id: 'id'
        }, [
            {name: 'id', mapping: 'id'},
            {name: 'desc', mapping: 'desc'}
        ])
    });
}