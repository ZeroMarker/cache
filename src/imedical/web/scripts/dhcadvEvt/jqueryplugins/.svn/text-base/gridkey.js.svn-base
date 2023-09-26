/*

$.extend($.fn.datagrid.methods, {
    keyCtr : function (jq) {
        return jq.each(function () {
            var grid = $(this);

            grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
                switch (e.keyCode) {
                case 38: // up
				    var rows = grid.datagrid('getRows');
                    var selected = grid.datagrid('getSelected');
                    if (selected) {
                        var index = grid.datagrid('getRowIndex', selected);
						if ((index - 1)<0)
						{
							return;
						}
                        grid.datagrid('selectRow', index - 1);
                    } else {
                        var rows = grid.datagrid('getRows');
                        grid.datagrid('selectRow', rows.length - 1);
                    }
                    break;
                case 40: // down
				    var rows = grid.datagrid('getRows');
                    var selected = grid.datagrid('getSelected');
                    if (selected) {
                        var index = grid.datagrid('getRowIndex', selected);
						if (index==rows.length-1)
						{
							return;
						}
                        grid.datagrid('selectRow', index + 1);
                    } else {
                        grid.datagrid('selectRow', 0);
                    }
                    break;
                }
            });
        });
    }
});

*/


$.fn.gridupdown=function(grid){
        
		grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
		switch (e.keyCode) {
	
		case 38: // up
			var rows = grid.datagrid('getRows');
			var selected = grid.datagrid('getSelected');
			if (selected) {
				var index = grid.datagrid('getRowIndex', selected);
				if ((index - 1)<0)
				{
					return;
				}
				grid.datagrid('selectRow', index - 1);
			} else {
				var rows = grid.datagrid('getRows');
				grid.datagrid('selectRow', rows.length - 1);
			}
			break;
		 case 40: // down
			var rows = grid.datagrid('getRows');
			var selected = grid.datagrid('getSelected');
			if (selected) {
				var index = grid.datagrid('getRowIndex', selected);
				if (index==rows.length-1)
				{
					return;
				}
				grid.datagrid('selectRow', index + 1);
			} else {
				grid.datagrid('selectRow', 0);
			}
			break;

		}


	  })



 }  