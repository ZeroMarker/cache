var hospid = session['LOGON.HOSPID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var BudgRealFromUrl = 'herp.budg.budgrealfromexe.csp'; 

var AddCompDRDs = new Ext.data.Store({
						proxy : "",
						url : commonboxURL+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						//autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});

			AddCompDRDs.on('load', function() {

						var Num=AddCompDRDs.getCount();
    					if (Num!=0){
						var id=AddCompDRDs.getAt(0).get('rowid');
						AddCompDRCombo.setValue(id);  
    					} 
					});

			var AddCompDRCombo = new Ext.form.ComboBox({
						id : 'AddCompDRCombo',
						name : 'AddCompDRCombo',
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						//allowBlank: false,
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 300,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});			
	
var itemGrid = new dhc.herp.Grid({
    title: '数据来源维护',
    width: 400,
    //edit:false,                   //是否可编辑
    //readerModel:'local',
    region: 'center',
    atLoad : true, // 是否自动刷新
    url: BudgRealFromUrl,
	listeners : {
		'cellclick' : function(grid, rowIndex, columnIndex, e) {
		   var record = grid.getStore().getAt(rowIndex);
		    // 根据条件设置单元格点击编辑是否可用 
		        //alert(columnIndex);
		        if ((record.get('rowid') !=="")&& (columnIndex == 2)) {
		              return false;
		        } else {return true;}
		 },
		 'celldblclick' : function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
				// 预算项目公式编辑
				if ((record.get('rowid') !=="")&& (columnIndex == 2)) {						
					return false;
				} else {
					return true;
				}
		}
    },
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'CompName',
        header: '医疗单位',
        dataIndex: 'CompName',
        width:150,
		editable:true,
		hidden: false,
		type:AddCompDRCombo,
		hidden: true
    },{
        id:'code',
        header: '编码',
        dataIndex: 'code',
        width:150,
		editable:true,
		hidden: false
    },{ 
        id:'name',
        header: '名称',
        dataIndex: 'name',
        width:150,
		editable:true,
		hidden: false
    }
	]

});

itemGrid.btnPrintHide();  //隐藏打印按钮








