/// 盘点公共组件部分
var STKTK_COMPOMENTS = {
	/*排序方式*/
	OrderType : function(domId){
		PHA.ComboBox(domId, {
	    	editable: false,
	        data: [
                { RowId: 'CODE', Description: '按药品代码' },
                { RowId: 'STKBIN', Description: '按货位' },
            ],
            onLoadSuccess: function(data){
						$(this).combobox('setValue', data[0].RowId);

			}
	    });
	},
	
}