 /**
 Creator:	�Ž���
 Desc:		�����ֵ�����ά��   �����б�
 */
//�ڶ�Ӧcspҳ���ȡ����
var rowid = strrowid;
var configName=strconfigName;
var fileds=filedstclom;
var filedsInitValue=filedsInitValue;
var defaultValue=defaultValue
//��ȡʱ�����ڵı�ͷ
var timeAndDatestr=timeAndDatestr
var datestrArray;
var tiemstrArray;
var tiemdateArray;
if(timeAndDatestr!=null){
	var timeAndDatestrArray=timeAndDatestr.split(",^^")
	var datestr=timeAndDatestrArray[0];
	var timestr=timeAndDatestrArray[1]
	if(datestr!=null){
		datestrArray=datestr.split(",");
	}
	if(timestr!=null){
	timestr=timestr.substring(0,timestr.length-1);
	tiemstrArray=timestr.split(",");
	}
	
}
tiemdateArray=[datestr,tiemstrArray];
var timehead='EndTime'
var datehead='EndDate'
//����ȫ���������
var pagesize=19;
var actionbtn=''
//������ͷ����
var headerfileds=fileds.split(",")

var myheader=new Array();
for(i=0;i<headerfileds.length+1;i++){
	if(i==0){myheader[0]='IDS'}
	if(i!=0){
	myheader[i]=headerfileds[i-1];
}}
var myheaderArr=new Array();
var widthcolm=(Ext.getBody().getWidth())/headerfileds.length
	myheader[i]=headerfileds[i];
	function rowNumNew(){
		for(i=0;i<headerfileds.length+1;i++){
		if (myheader[i]=='ID')
		{
			var a= new Ext.grid.Column({
			header:myheader[i],
			dataIndex:myheader[i]+'',
			hidden:true,
			sortable: true
		});
		}else{
		var a= new Ext.grid.Column({
			header:myheader[i],
			dataIndex:myheader[i]+'',
			sortable: true
		});}
		myheaderArr[i]=a;}
		return myheaderArr;
	}

//���ݱ�ͷ���鴴����ͷ
var cm = new Ext.grid.ColumnModel( rowNumNew());
var myheader11=new Array();
function GetGridStore(){
	var ds=new Ext.data.JsonStore({
		proxy: new Ext.data.HttpProxy({url:'../CT.WS.web.DicStdmaintainData.cls'}),
		root: 'rows',
		totalProperty: "results",
		method: 'POST',
		baseParams: { start: 0, limit:pagesize},
		fields: myheader,
		listeners: {
		'beforeload': 
			//����ʱ�����������
			function(store,options) {
				if(actionbtn=='deleteidbtn')
				{
					var totalPages=Math.floor(store.getTotalCount()/pagesize);
					if((store.getCount()==1)&&(totalPages>=1)){
					
					var new_params1={start:totalPages*pagesize-pagesize, limit:pagesize};

					Ext.apply(options.params,new_params1);
					}

				
				}
				var new_params={selID: selIDData(), condition:conditionData(),actionbtn:actionbtn,dataName:dataNameData()}; 
				Ext.apply(options.params,new_params); 
			}
	}
});
return  ds;
}
//store����
store=GetGridStore();
store.load();
//����gridpanel
var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store:store,
	stripeRows:true,
    cm: cm,
	title:'�����б�',
	height:460,
	sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	 bbar: new Ext.PagingToolbar({
        id: "pagingToolbar",
        store: store,
        pageSize:pagesize,
        displayInfo: true,
        displayMsg: '�� {0} ����  {1} ��, һ�� {2} ��',
        beforePageText: 'ҳ��',
        afterPageText: '��ҳ�� {0}',
        firstText: '��ҳ',
        prevText: '��һҳ',
        nextText: '��һҳ',
        lastText: 'ĩҳ',
		refreshText:'ˢ��',
        emptyMsg: "û�м�¼"
    }),
	listeners: {
		'click': function() {		
			gettableData();	
	}}
});
//����ҳ���·���panel
var paneltextField='';
var gridheadlength=cm.getColumnCount();
var paneltextField = new Ext.Panel({
	id:'paneltextField',
	autowidth:true,
	bodyStyle:'color:red;height:200', 
	frame:true,
	layout:'hbox', 
	border:false,
	autoScroll:true,
	html:''
});
//�����д�����panel
var panelWidth=document.body.clientWidth/gridheadlength
var xtypeByTextfield='';
var formatByTextfield='';
var xtypeByTextfields=new Array();
var formatByTextfields=new Array();
var textfieldsdData=new Array();
var textfieldsdDataTime=new Array();
for(i=1;i<gridheadlength;i++){
	for(h=0;h<datestrArray.length;h++){
		if(datestrArray[h]==cm.getColumnHeader(i)){
			xtypeByTextfields[i]='datefield';
			formatByTextfields[i]='Y-m-d';
			textfieldsdData[i]=cm.getColumnHeader(i);
		}
	}
	if (tiemstrArray!=null)
	for(j=0;j<tiemstrArray.length;j++){
		if(tiemstrArray[j]==cm.getColumnHeader(i)){
			xtypeByTextfields[i]='timefield';
			formatByTextfields[i]='H:i';
			textfieldsdDataTime[i]=cm.getColumnHeader(i);
		}

	}
	if(xtypeByTextfields[i]!='datefield'&&xtypeByTextfields[i]!='timefield'){
		xtypeByTextfields[i]='textfield';
	}


}
for(i=1;i<gridheadlength;i++){
  var hiddens=false;
  if (cm.getColumnHeader(i)=='ID')
  {
	  hiddens=true;
  }
	var paneltextFieldchildren=cm.getColumnHeader(i);
	var paneltextFieldchildrens=new Ext.Panel({
		id:"child_gridrowsdata"+i,
		layout: {
			type: 'vbox',  
			padding:'0', 
			align:'left' 
		}, 
		height:50,
		autoScroll:true,
		flex: 1,
		width:panelWidth,
		items:[ {
			//���ɶ�̬��ǩ
			id:paneltextFieldchildren+'label',
			xtype:'label',
			text: cm.getColumnHeader(i),
			flex:1,
			width:panelWidth,
			name: "labelname"+i,
			fieldLabel: "fieldLabel"+i,
			hidden:hiddens,
			anchor: '-1'
			}, {
			//���ɶ�̬�����textfield
			id:paneltextFieldchildren+'textfield',
			flex:1,
			width:panelWidth,
			xtype: xtypeByTextfields[i],
			name: "textfield"+i,
			//readOnly: false,
			format: formatByTextfields[i],
			fieldLabel: 'fieldLabel'+i,
			hidden:hiddens,
			height:22,
			anchor: '-1'
		}]
			
	});
	//�����panel
	paneltextField.add(paneltextFieldchildrens);
	paneltextField.doLayout();
}
//ҳ����ʾ
var eprPortal = new Ext.Viewport({
    id: 'patientListPort',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
	title:'�����б�',
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
	items: [
	{ 
			border: false,
			id: 'patextField',
			region: "south",
			layout: "fit",
			margins:'0 0 0 0',
			height:100,
			items:[{
				layout: false,
				id: 'paneltextFieldlist',
					
				items:paneltextField,
				bbar: [
				{ 
					id: 'btnInsertData',text: '����',cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/new.gif',pressed: false
				},
				'-',
				{
					id: 'btnUpdateData',text: '�޸�', cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/eprwrite.gif',pressed: false
				},
				'-',
				{
					id: 'btnDelete',text: 'ɾ��',cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/btnClose.gif',pressed: false
				}]
				}]
	},
	{ 
    	border: false,
		region: "center",
		layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid
	}]

	}]
});
//��ѯ����
var btnSearch= parent.Ext.getCmp('btnSearch'); 
btnSearch.on('click',function(){
	btnSearch='btnSearch';
	actionBtn="btnSearch";
	var SearchValue=parent.Ext.getCmp('cbxTableName').getRawValue();
	if(SearchValue==""||SearchValue==null){
		Ext.Msg.alert('������ʾ', '��ѡ������Ҫ[���ô������]');
		return;
	}else{
	store.load();
	}
});

//ѡ����Ҫ����ʱ����ҳ���µ������ֵ�¼�
var grid=Ext.getCmp('eprEpisodeGrid');
function gettableData(){
	for(i=1;i<gridheadlength;i++){	
		if(grid.getSelectionModel().getSelected()!=null){
			if(!Ext.getCmp(cm.getColumnHeader(i)+'textfield').disabled){
				Ext.getCmp(cm.getColumnHeader(i)+'textfield').setValue(grid.getSelectionModel().getSelected().data[cm.getDataIndex(i)+''].trim()); 
			}
		}
	}
}

//��ȡѡ���id
function selIDData(){
	var selID='';
		var grid=Ext.getCmp('eprEpisodeGrid');
		if(grid==null){
		}else{
		if(grid.getSelectionModel().getSelected()==null){}else{
		return grid.getSelectionModel().getSelected().data['ID'];
		}
	}
	return selID
}
//��ȡ�������ô��������id
function conditionData(){
	return strcondition =rowid+"^^"+configName;
}
//��ȡ�������������

function dataNameData(){
	var baseParamsString='';
	var cbxTableName =  parent.Ext.getCmp('cbxTableName').getRawValue();
	for(i=1;i<gridheadlength;i++){
		i
		var txtValueTexts='';
		var dataNames='dataName'+i;
		var txtValueTexts='txtValueText'+i
		var dataNames=cm.getDataIndex(i)+'';

		//Ext.util.Format.date(Ext.getCmp("�ؼ�ID").getValue(),'Y-m-d')
		if(cm.getColumnHeader(i)==textfieldsdData[i]){
			
			
			
			var valuedate=Ext.getCmp(cm.getColumnHeader(i)+'textfield').getValue()+"";
			txtValueTexts= "#*#$";
			if(valuedate!=null&&valuedate.length>1){
				if(textvaluedate==''&&textvaluedate.length<1){
					
				Ext.Msg.alert("�������","���ڲ��Ϸ����ʽ����ȷ������ΪYYYY-MM-DD��ʽ!")
				
			}else{
			var textvaluedate=Ext.util.Format.date(Ext.getCmp(cm.getColumnHeader(i)+'textfield').getValue(),'Y-m-d');
			txtValueTexts="#*#$"+textvaluedate
			}}
		}
		if(cm.getColumnHeader(i)==textfieldsdDataTime[i]){
			var timevalue=Ext.getCmp(cm.getColumnHeader(i)+'textfield').getValue();
			var timevalues=timevalue.split(":");
			txtValueTexts= "@##@";
			if(timevalues[0]<=24&&timevalues[0]>=0&&timevalues[1]>=0&&timevalues<=59){
				
				Ext.Msg.alert("�������","���Ϸ����ʽ����ȷ������ΪHH:MM��ʽ!")
				
			}else{
			 txtValueTexts= "@##@"+Ext.getCmp(cm.getColumnHeader(i)+'textfield').getValue();
			}
			 
		}
		if(cm.getColumnHeader(i)!=textfieldsdData[i]&&cm.getColumnHeader(i)!=textfieldsdDataTime[i]){
		 txtValueTexts= Ext.getCmp(cm.getColumnHeader(i)+'textfield').getValue();
		}
		if(cm.getColumnHeader(i)!='ID'){
		baseParamsString=baseParamsString+dataNames+"|:|"+txtValueTexts+"^^^"
		}
		
	}
	var baseParamsStrings=baseParamsString.substring(0,baseParamsString.length-3);

	return baseParamsStrings;
}
//ȡ��ѡ���е�id
//��������
var btnInsertData= Ext.getCmp('btnInsertData'); 
btnInsertData.on('click',function(){
	actionbtn='btnInsertData';
	textValues='';
	for(i=1;i<gridheadlength;i++){
		if(!Ext.getCmp(cm.getColumnHeader(i)+'textfield').disabled){
			textValues=textValues+Ext.getCmp(cm.getColumnHeader(i)+'textfield').getValue()
		}
	}
	if(textValues.trim().length<1||textValues==null){
		Ext.Msg.alert('������ʾ', '����д��Ҫ���ӵ�����');
	}else{
		store.reload();
		actionbtn='';
		
	}
	
});

		
//�޸�����
var btnUpdateData= Ext.getCmp('btnUpdateData'); 
btnUpdateData.on('click',function(){
//��ȡҪ�޸����ݵ�id
		actionbtn="updateidbtn"
	if(grid.getSelectionModel().getSelected()==null){
		Ext.Msg.alert('ѡ�����', '��ѡ������Ҫ[�޸�]����');
	}else{
		store.reload();
		actionbtn='';
	}
});


var btnDeleteData= Ext.getCmp('btnDelete'); 
btnDeleteData.on('click',function(){
	if(grid.getSelectionModel().getSelected()==null){
		Ext.Msg.alert('ѡ�����', '��ѡ������Ҫ[ɾ��]����');
	}else{
		var selID=grid.getSelectionModel().getSelected().data['ID']
		//��ȡҪ�޸����ݵ�id
		actionbtn='deleteidbtn';
		//alert(store.getCount()+"---")
		
		store.reload();
		actionbtn='';
		
		
		for(i=1;i<gridheadlength;i++){	
		if(grid.getSelectionModel().getSelected()!=null){
			if(!Ext.getCmp(cm.getColumnHeader(i)+'textfield').disabled){
				Ext.getCmp(cm.getColumnHeader(i)+'textfield').setValue(''); 
			}
		}
	}
}
});
//ȷ��textfiled�Ƿ񲻿ɱ༭
var rowsCount=store.getCount();
var iniValueRulrow=filedsInitValue.split(",")
for(j=0;j<iniValueRulrow.length;j++){
	var rowsName=iniValueRulrow[j].split("=")
	var rowsNameLeft=rowsName[0];
	var rowsNameRight=rowsName[1];
	
	if(Ext.getCmp(rowsNameLeft+'textfield')!=null){
		Ext.getCmp(defaultValue+'textfield').setDisabled (true);
		Ext.getCmp(defaultValue+'textfield').setReadOnly (true);
		Ext.getCmp(rowsNameLeft+'textfield').setValue(rowsNameRight);

	}	

}
//������ʽʱ���Ƿ�Ϸ�
//Desc: ������ʽ�ж������Ƿ�Ϸ�
function regDate(ctrlValue) {
    var reg = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/;
    if (reg.test(ctrlValue)) 
        return true;
    return false;
}
