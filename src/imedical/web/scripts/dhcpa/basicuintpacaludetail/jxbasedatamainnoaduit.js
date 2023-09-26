/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */
 //你写的东西有点绕，我被拧麻花了
function getValueByParam(paras){ 
	var url = location.href; 
	var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
	var paraObj = {} 
	for (i=0; j=paraString[i]; i++){ 
	paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
} 

var returnValue = paraObj[paras.toLowerCase()]; 
	if(typeof(returnValue)=="undefined"){ 
	return ""; 
	}else{ 
	return returnValue; 
	} 
}
var UnitSchemDetailurl='dhc.pa.basicuintpacaludetailexe.csp';
var uploadUrl = 'http://10.0.1.142:8080/uploadexcel/uploadexcel';
//var uploadUrl = 'http://127.0.0.1:8080/uploadexcel/uploadexcel';
var userCode = session['LOGON.USERCODE'];
var userID = session['LOGON.USERID'];
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};




 
//配件数据源
var JXBaseDataTabUrl = 'dhc.pa.basicuintpacaludetailexe.csp';
var JXBaseDataTabProxy= new Ext.data.HttpProxy({url:JXBaseDataTabUrl + '?action=list'});


//设置默认排序字段和排序方向
//JXBaseDataTabDs.setDefaultSort('KPIName', 'desc');

//数据库数据模型
var JXBaseDataTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.CheckboxSelectionModel(),
	
	 new Ext.grid.RowNumberer(),
	 {
		header: "所属绩效单元",
		dataIndex: 'parRefName',
		width: 130,
		sortable: true
	},{
		header: "考核期间",
		dataIndex: 'period',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '期间类型',
		dataIndex: 'periodTypeName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '考核指标',
		dataIndex: 'KPIName',
		width: 210,
		sortable: true
	}


	,{
		header: '计量单位',
		dataIndex: 'calUnitName',
		width: 90,
		sortable: true,
		align: 'center'
	}



	,{
		header: "实际值",
		dataIndex: 'actualValue',
		width: 100,
		sortable: true,
		renderer:format,
		align: 'right',
		editor:new Ext.form.TextField({
		
		//regex:/^\d$/, 
		//regex:/^[0-9]+\.{0,1}[0-9]{0,2}$/,
		regex:/[-]?\d+(?:\.\d+)?$/,
		
		regexText:"只能够输入数字",
		allowBlank:false
		
		
		})
		
		
	},{
		header: "审核时间",
		dataIndex: 'auditDate',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "审核人员",
		dataIndex: 'auditUserName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "数据状态",
		dataIndex: 'dataStateName',
		width: 90,
		sortable: true,
		align: 'center'
	}/**
	,
	{
		header: "描述",
		dataIndex: 'desc',
		width:400,
		sortable: true,
		align: 'left'
	}**/
]);

//初始化默认排序功能
JXBaseDataTabCm.defaultSortable = true;





//tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addButton,'-',
//initButton,'-',importButton,'-',excelButton,
//'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
//初始化搜索字段
var JXBaseDataSearchField ='KPIName';


var schemedistDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

schemedistDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=schem',method:'POST'})
	
});

var JXBaseDataTabDs = new Ext.data.Store({
	autoLoad:true,
	proxy: JXBaseDataTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'parRef',
		'parRefName',
		'rowid',
		'childSub',
		'period',
		'periodType',
		'periodTypeName',
		'KPIDr',
		'KPIName',
		'actualValue',
		'auditDate',
		'auditUserDr',
		'auditUserName',
		'dataState',
		'dataStateName',
		'desc',
		'calUnitName'
	]),
    // turn on remote sorting
    remoteSort: true
});

JXBaseDataTabDs.on('beforeload', function(ds, o){
	//alert(Ext.getCmp('schemedistField').getValue());
	///extremum = getValueByParam('extremum');
	ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.basicuintpacaludetailexe.csp?action=list&period='+getValueByParam('period')+'&periodType='+getValueByParam('periodType')+'&userID='+getValueByParam('userID')+'&start='+getValueByParam('start')+'&limit='+getValueByParam('limit')+'&kpidrs='+getValueByParam('kpidrs')+'&deptdr='+getValueByParam('deptdr'),method:'POST'});
});
//表格
var JXBaseDataTab = new Ext.grid.EditorGridPanel({
	title: '基本数据管理',
	store: JXBaseDataTabDs,
	
	cm: JXBaseDataTabCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.CheckboxSelectionModel(),
	loadMask: true
	/*,
	//tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addButton,'-',initButton,'-',importButton,'-',excelButton,'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
	//tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addMenu,'-',saveB,'-',delButton1,'-',aduitButton,'-',CancelAduitButton],
	tbar:['考核期间:',periodField,'-','期间类型:',pType,'-',addMenu,'-',delButton1],
	 listeners : { 
       'render': function(){ 
            tbar1.render(this.tbar); 
			tbar2.render(this.tbar); 
			tbar3.render(this.tbar); 
			tbar4.render(this.tbar); 
			tbar5.render(this.tbar); 
        } 
     } ,



	bbar:JXBaseDataTabPagingToolbar
	*/
	});


JXBaseDataTab.on('cellclick',function( g, rowIndex, columnIndex, e ){

//alert(columnIndex);
JXBaseDataTabCm.setEditable (7,true);
	if(columnIndex==7){

	var tmpRec=JXBaseDataTab.getStore().data.items[rowIndex];


	if (tmpRec.data['dataState']==1)
		
		{
			JXBaseDataTabCm.setEditable (7,false);
			Ext.Msg.show({title:'错误',msg:'审核通过的数据不可修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
			}
		
		}

});




//----------------------------------实际值修改后直接保存---------------------------------------------------------


function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=JXBaseDataTabDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
       
				var actualValue = mr[i].data["actualValue"].trim();
             
				var myRowid = mr[i].data["rowid"].trim();
     }  
	Ext.Ajax.request({
							url:'dhc.pa.basicuintpacaludetailexe.csp?action=update&rowid='+myRowid+'&aValue='+actualValue,
							//waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									//Ext.Msg.show({title:'注意',msg:'数据保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load();
									//JXBaseDataTab.getStore().modified =[];  //清空store的修改数据组的记录
								   //this.store.commitChanges(); 
								
								}else{
									var message="数据保存失败,请检查数据格式！";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
	 
}
JXBaseDataTab.on("afteredit", afterEdit, JXBaseDataTab);    
