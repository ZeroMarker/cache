/// �̵㹫���������
var STKTK_COMPOMENTS = {
	/*����ʽ*/
	OrderType : function(domId){
		PHA.ComboBox(domId, {
	    	editable: false,
	        data: [
                { RowId: 'CODE', Description: '��ҩƷ����' },
                { RowId: 'STKBIN', Description: '����λ' },
            ],
            onLoadSuccess: function(data){
						$(this).combobox('setValue', data[0].RowId);

			}
	    });
	},
	
}