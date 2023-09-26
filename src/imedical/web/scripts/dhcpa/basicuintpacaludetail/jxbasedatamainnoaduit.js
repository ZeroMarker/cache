/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */
 //��д�Ķ����е��ƣ��ұ�š�黨��
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




 
//�������Դ
var JXBaseDataTabUrl = 'dhc.pa.basicuintpacaludetailexe.csp';
var JXBaseDataTabProxy= new Ext.data.HttpProxy({url:JXBaseDataTabUrl + '?action=list'});


//����Ĭ�������ֶκ�������
//JXBaseDataTabDs.setDefaultSort('KPIName', 'desc');

//���ݿ�����ģ��
var JXBaseDataTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.CheckboxSelectionModel(),
	
	 new Ext.grid.RowNumberer(),
	 {
		header: "������Ч��Ԫ",
		dataIndex: 'parRefName',
		width: 130,
		sortable: true
	},{
		header: "�����ڼ�",
		dataIndex: 'period',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '�ڼ�����',
		dataIndex: 'periodTypeName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: '����ָ��',
		dataIndex: 'KPIName',
		width: 210,
		sortable: true
	}


	,{
		header: '������λ',
		dataIndex: 'calUnitName',
		width: 90,
		sortable: true,
		align: 'center'
	}



	,{
		header: "ʵ��ֵ",
		dataIndex: 'actualValue',
		width: 100,
		sortable: true,
		renderer:format,
		align: 'right',
		editor:new Ext.form.TextField({
		
		//regex:/^\d$/, 
		//regex:/^[0-9]+\.{0,1}[0-9]{0,2}$/,
		regex:/[-]?\d+(?:\.\d+)?$/,
		
		regexText:"ֻ�ܹ���������",
		allowBlank:false
		
		
		})
		
		
	},{
		header: "���ʱ��",
		dataIndex: 'auditDate',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "�����Ա",
		dataIndex: 'auditUserName',
		width: 90,
		sortable: true,
		align: 'center'
	},{
		header: "����״̬",
		dataIndex: 'dataStateName',
		width: 90,
		sortable: true,
		align: 'center'
	}/**
	,
	{
		header: "����",
		dataIndex: 'desc',
		width:400,
		sortable: true,
		align: 'left'
	}**/
]);

//��ʼ��Ĭ��������
JXBaseDataTabCm.defaultSortable = true;





//tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addButton,'-',
//initButton,'-',importButton,'-',excelButton,
//'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
//��ʼ�������ֶ�
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
//���
var JXBaseDataTab = new Ext.grid.EditorGridPanel({
	title: '�������ݹ���',
	store: JXBaseDataTabDs,
	
	cm: JXBaseDataTabCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.CheckboxSelectionModel(),
	loadMask: true
	/*,
	//tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addButton,'-',initButton,'-',importButton,'-',excelButton,'-',saveB,'-',delButton,'-',aduitButton,'-',CancelAduitButton,'-',delButton1],
	//tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addMenu,'-',saveB,'-',delButton1,'-',aduitButton,'-',CancelAduitButton],
	tbar:['�����ڼ�:',periodField,'-','�ڼ�����:',pType,'-',addMenu,'-',delButton1],
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
			Ext.Msg.show({title:'����',msg:'���ͨ�������ݲ����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
			}
		
		}

});




//----------------------------------ʵ��ֵ�޸ĺ�ֱ�ӱ���---------------------------------------------------------


function afterEdit(obj){    //ÿ�θ��ĺ󣬴���һ�θ��¼�   
          var mr=JXBaseDataTabDs.getModifiedRecords();//��ȡ���и��¹��ļ�¼ 
		   for(var i=0;i<mr.length;i++){   
       
				var actualValue = mr[i].data["actualValue"].trim();
             
				var myRowid = mr[i].data["rowid"].trim();
     }  
	Ext.Ajax.request({
							url:'dhc.pa.basicuintpacaludetailexe.csp?action=update&rowid='+myRowid+'&aValue='+actualValue,
							//waitMsg:'�����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									//Ext.Msg.show({title:'ע��',msg:'���ݱ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									JXBaseDataTabDs.load();
									//JXBaseDataTab.getStore().modified =[];  //���store���޸�������ļ�¼
								   //this.store.commitChanges(); 
								
								}else{
									var message="���ݱ���ʧ��,�������ݸ�ʽ��";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
	 
}
JXBaseDataTab.on("afteredit", afterEdit, JXBaseDataTab);    
