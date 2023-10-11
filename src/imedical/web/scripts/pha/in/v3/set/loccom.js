
/**
 * ģ��:     ���ڲ�˵� �����������б�
 * ��д����: 2022-05-27
 * ��д��:   yangsj
  *  scripts/pha/in/v3/set/loccom.js
 */
 
 var Loc_Com = {
		 Init : function(gridId, gridBarId, Fn){
			 var columns = [
		        [
		            { field: 'locId', 	title: 'locId', 		hidden: true },
		            { field: 'hospId', 	title: 'hospId', 		hidden: true },
		            { field: 'locCode', title: '����',  		align: 'left',		width: 100	},  
		            { field: 'locDesc', title: '����',  		align: 'left',		width: 200	}
		        ]
		    ];
		    var dataGridOption = {
		        url: PHA.$URL,
		        gridSave: false,
		        queryParams: {
		            pClassName : 'PHA.IN.Loccom.Api',
		            pMethodName: 'QueryLocByGroup',
		            pPlug	   : 'datagrid',
		            pJson      : '{}',
		        },
		        pagination: false,
		        fitColumns: true,
		        fit: true,
		        //idField: 'locId',
		        columns: columns,
		        toolbar: '#' + gridBarId,  
		        exportXls: false,
		        isAutoShowPanel: true,
		        isCellEdit: false,
		        onClickRow: function (rowIndex, rowData){
			        if (rowData){
				        var locId = rowData.locId;
				        Fn();
			        }
		        },
			    onDblClickRow: function (rowIndex, rowData){}
		    };
		    PHA.Grid(gridId, dataGridOption);
	 }
 }
