//����ؼ���ȫ�ֱ���
/* var cycleIdCookieName="ThCycleDr";
var periodTypeNameCookieName="ThPeriodTypeName";
var periodTypeCookieName="ThPeriodType";
var periodCookieName="ThPeriod";
var LabelIdCookieName="ThLabelDr";
var kpiIdCookieName="ThKpiDr";
var nameStr=cycleIdCookieName+"^"+periodTypeNameCookieName+"^"+periodTypeCookieName+"^"+periodCookieName+"^"+LabelIdCookieName+"^"+kpiIdCookieName;
var dataStr="";
var data="";
var data1=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
var data3=[['1','1~6�ϰ���'],['2','7~12�°���']];
var data4=[['0','00']];
var count1=0;
var count2=0;
var count3=0; */

var userCode = session['LOGON.USERCODE'];
var userdr = session['LOGON.USERID'];
//var Adm=parent.parent.frames[0].document.getElementById("PatientID").value;
var frm =dhcsys_getmenuform();
//var Adm=frm.document.getElementById("EpisodeID").value
var Adm=frm.EpisodeID.value;
//var Adm=document.getElementById("EpisodeID").value
//alert(Adm);

//==========================================================
function formatDate(value){
	alert("333");
	return value?value.dateFormat('Y-m-d'):'';
};

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var userCode= session['LOGON.USERCODE'];

/* var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('RegNoFileld').getRawValue()+'&active=Y',method:'POST'})
	
});
 */
var RegNoFileld = new Ext.form.TextField({
	id: 'RegNoFileld',
	fieldLabel:'���',
	width:180,
	listWidth : 180,
	allowBlank: false,
	//store: cycleDs,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'RegNoFileld',
	//minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	style:"color:red;" ,
	editable:true,
	disabled:true
});
/*
cycleDs.on('load', function(ds, o){
	RegNoFileld.setValue(getCookie(cycleIdCookieName));
	count1=1;
});
*/

var PaadmFileld = new Ext.form.TextField({
	id: 'PaadmFileld',
	fieldLabel: '�ڼ�����',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});



var LocFileld = new Ext.form.TextField({
	id: 'LocFileld',
	fieldLabel: '',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

/* PaadmFileld.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
}); */

//����ҳ��ʱ��Ⱦ�ؼ�
/*
setComboValueFromClientOfNotChange(PaadmFileld,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//����ҳ��ʱ��Ⱦ�ؼ�
setComboValueFromClientOfChange(periodStore,data,LocFileld,periodCookieName);
*/
/* var LabelDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','shortCutFreQuency'])
});

LabelDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=Label2&str='+Ext.getCmp('Label').getRawValue()+'&active=Y'+'&periodType='+Ext.getCmp('PaadmFileld').getValue()+'&userCode='+userCode,method:'POST'})

}); */
var Label = new Ext.form.TextField({
	id: 'Label',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	anchor: '90%',
	editable:true,
	//emptyText:'...',
	selectOnFocus: true,
	forceSelection: true,
	enableKeyEvent: true,
	 listeners : {
    'specialkey' : function(field, e) {
     if (e.getKey() == Ext.EventObject.ENTER) {
      //alert(333);
	  Reg();
	  Ext.getCmp('Label').setValue("");
	  Ext.getCmp('Label').focus(false, 100);
     }
    }
   }
	��/* listeners : {
����specialkey : function(field, event) { //����specialkey �¼�
����if (event.getKey() == event.ENTER) { //����������ʱ��������enter��
���� alert(222);
����}
}
	} */
});
Ext.getCmp('Label').focus(false, 100);
//�ڼ�����뷽����ѯ�Ķ�����������
/* function searchFun(periodType){
	Label.setRawValue("");
	LocFileld.setRawValue("");
	LabelDs.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=Label3&active=Y'+'&periodType='+getCookie(periodTypeCookieName),method:'POST'});
	LabelDs.load({params:{start:0, limit:Label.pageSize}}); */
	/*
	if(getCookie(periodTypeCookieName)==periodType){
		count2=3;
		setComboValueFromServer(Label,LabelIdCookieName);
		setComboActValueFromClientOfChange(LocFileld,periodCookieName);
	}else{
		LabelDs.on('load', function(ds, o){
			Label.setValue("");
			count2=2;
		});
	}
	*/
/* }; */
//setAndLoadComboValueFromServer(LabelDs,Label,LabelIdCookieName);

/* var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

KPIDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=kpi&LabelDr='+Ext.getCmp('Label').getValue()+'&userCode='+userCode,method:'POST'})
	
}); */

var PationField = new Ext.form.TextField({
	id: 'PationField',
	fieldLabel: '',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	editable:false
});

/* KPIDs.on('load', function(ds, o){
	//PationField.setValue(getCookie(kpiIdCookieName));
	//count3=1;
});

Label.on("select",function(cmb,rec,id){
	search(cmb.getValue());
}); */

/* function search(LabelDr){
	PationField.setValue("");
	PationField.setRawValue("");
	//KPIָ��
	KPIDs.load({params:{start:0, limit:PationField.pageSize}});
	/*
	if(getCookie(LabelIdCookieName)==LabelDr){
		setComboValueFromServer(PationField,kpiIdCookieName);
	}else{
		KPIDs.on('load', function(ds, o){
			PationField.setValue("");
		});
	}
	*/
/* }; */ 
//==============================================================================================================================
function testStringAjax()  
{  
   // alert(1);
    var areaName = "";  
    Ext.Ajax.request({  
        method: 'POST',// ����ʽ  
        url: 'cssd.registerpackageexe.csp',//URL   
        params: {areaName:""+Adm+"",action:"getadminfo"},//Ҫ���ݵĲ������˲���������һ�����  
        waitMsg: '���ݸ����У����Ժ�...',  
        success: function(response,options){  
            var textDoc = response.responseText;//ע��˴��õ��� responseText   
			//alert(textDoc);
            if(textDoc!=null)  
            {  
                var vs = textDoc.split('^'); 
				Ext.getCmp('RegNoFileld').setValue(vs[0]);
			Ext.getCmp('PaadmFileld').setValue(Adm);
			Ext.getCmp('LocFileld').setValue(vs[2]);
			Ext.getCmp('PationField').setValue(vs[1]);
		 Ext.getCmp('Label').focus(false, 100);
                //document.getElementById("zcl").innerHTML = vs[0];//���õ���ֵչʾ��ҳ����  
                //document.getElementById("zyc").innerHTML = vs[1];  
            }  
        },  
        failure: function(response,options){  
            Ext.Msg.alert("��Ϣ��ʾ", "��ȡ���ݿ����ݳ���,���Ժ����ԣ�");  
        },  
        autoAbort:false  
    });  
} 
var sm = new Ext.grid.CheckboxSelectionModel();

var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'../csp/cssd.registerpackageexe.csp?action=list'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}, [
          'rowid',
		  'RegNo',
		  'PatName',
		  'PatLoc',
		  'label',
		  'packageName',
		  'CountNurseDr',
		  'CountNurseTime'
		]),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'�������Ǽ�',
	region:'north',
	frame:true,
	height:90,
	items:[{
		xtype: 'panel',
		layout:"column",
		hideLabel:true,
		isFormField:true,
		items:[
				{columnWidth:.09,xtype:'label',text: '�ǼǺ�:'},
				RegNoFileld,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.1,xtype:'label',text: '�����:'},
				PaadmFileld,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.09,xtype:'label',text: '����:'},
				LocFileld,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.09,xtype:'label',text: '����:'},
				PationField
			]
	
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
			{columnWidth:.05,xtype:'label',text: '��ǩ:'},
			Label,
			{columnWidth:.02,xtype:'displayfield'},
	
			/* {columnWidth:.05,xtype:'button',text: '��ѯ',name: 'bc',tooltip: '��ѯ',handler:function(){find()},iconCls: 'add'}, */
			{columnWidth:.01,xtype:'displayfield'},
			{columnWidth:.05,xtype:'button',text: 'ɾ��',name: 'bc',tooltip: 'ɾ��',handler:function(){think()},iconCls: 'add'}
			]
		}
	]
});

//��ѯ��ť������
find = function(){
	
	/* var cycleDr=Ext.getCmp('RegNoFileld').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodId=Ext.getCmp('LocFileld').getValue();
	if((periodId=="")||(periodId=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var LabelDr=Ext.getCmp('Label').getValue();
	if((LabelDr=="")||(LabelDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var kpiDr=Ext.getCmp('PationField').getValue();
	if((kpiDr=="")||(kpiDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ָ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var periodType=Ext.getCmp('PaadmFileld').getValue();
	var periodTypeName=Ext.getCmp('PaadmFileld').getRawValue();
	
	
	vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,cycleDr:cycleDr,LabelDr:LabelDr,kpiDr:kpiDr,periodId:periodId}});
	
	dataStr=cycleIdCookieName+"^"+cycleDr+"!"+LabelIdCookieName+"^"+LabelDr+"!"+periodCookieName+"^"+periodId+"!"+kpiIdCookieName+"^"+kpiDr+"!"+periodTypeNameCookieName+"^"+periodTypeName+"!"+periodTypeCookieName+"^"+periodType;
	setBathCookieValue(dataStr); */
}

var pagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: vouchDetailST,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		doLoad:function(C){
			/* var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['cycleDr']=Ext.getCmp('RegNoFileld').getValue();
			B['LabelDr']=Ext.getCmp('Label').getValue();
			B['kpiDr']=Ext.getCmp('PationField').getValue();
			B['periodId']=Ext.getCmp('LocFileld').getValue();
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B})
			} */
		}
});

var AllDataItemsCm = new Ext.grid.ColumnModel([
	sm,
	new Ext.grid.RowNumberer(),
	{
		header: '�ǼǺ�',
		dataIndex: 'RegNo',
		width: 150,
		align: 'left',
		sortable: false
    },{
		header: '����',
		dataIndex: 'PatName',
		width: 150,
		align: 'right',
		//renderer:format,
		sortable: false
    },{
		header: '����',
		dataIndex: 'PatLoc',
		width: 150,
		align: 'right',
		//renderer:format,
		sortable: false
    },{
		header: '��ǩ',
		dataIndex: 'label',
		width: 150,
		align: 'right',
		//renderer:format,
		sortable: false
    },{
        header: '����',
        dataIndex: 'packageName',
        width: 150,
        align: 'left',
        sortable: false
		
    },{
        header: '������',
        dataIndex: 'CountNurseDr',
        width: 150,
        align: 'left',
        sortable: false,
		editor:new Ext.form.TextField({
			allowBlank:true
		})
    },{
        header: 'ʱ��',
        dataIndex: 'CountNurseTime',
        width: 150,
        align: 'center',
        sortable: false
    },
	{
		header: "rowid",
		dataIndex: 'rowid',
		width: 120,
		//renderer:formatDate,
		align: 'center',
		sortable: false,
		hidden: true
	}
/**
,{
        header: '�����',
        dataIndex: 'estAUserName',
        width: 70,
        align: 'center',
        sortable: true
    },{
		header: "���ʱ��",
		dataIndex: 'estADate',
		width: 70,
		renderer:formatDate,
		align: 'center',
		sortable: true
	}

**/
]);
var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:AllDataItemsCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	sm:sm,
	stripeRows:true,
	loadMask:true,
	bbar: pagingToolbar
});

vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,Adm:Adm}});
/*
//��ȡ�������cell��id
autohisoutmedvouchMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	point=columnIndex;
})
*/

//������ť������
Reg=function()
{
	var label=Ext.getCmp('Label').getValue();
	if(Adm==""||Adm==null)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	Ext.Ajax.request({
			url:'../csp/cssd.registerpackageexe.csp?action=Reg&Label='+label+'&Adm='+Adm+'&userdr='+userdr,
			waitMsg:'ˢ����...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					//Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,Adm:Adm}});
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'��ʾ',msg:'�ظ��Ǽ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='5'){
						Ext.Msg.show({title:'��ʾ',msg:'����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='3'){
						Ext.Msg.show({title:'��ʾ',msg:'����ı�ǩ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='4'){
						Ext.Msg.show({title:'��ʾ',msg:'��������ǩû�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='6'){
						Ext.Msg.show({title:'��ʾ',msg:'��������ǩû�з���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='7'){
						Ext.Msg.show({title:'��ʾ',msg:'�������ѱ��ٻ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
					 	Ext.getCmp('Label').focus(false, 100);
						return;
					}
				}
			},
			scope: this
		});
}
function focusReg()
{
	//alert(1);
	Ext.getCmp('Label').focus(false, 100);
}

 think = function(){

	
	var obj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=obj.length;
	if(length<1){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{
		var dataInfo="";
		for(var i=0;i<length;i++){
			
			var data=obj[i].get('rowid');
			
				
			if(dataInfo==""){ 
				dataInfo=data;
			}else{
				dataInfo=dataInfo+"!"+data;
			}
		}
		alert(dataInfo);
		Ext.Ajax.request({
			url:'../csp/cssd.registerpackageexe.csp?action=del&rowid='+dataInfo,
			waitMsg:'ˢ����...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,Adm:Adm}});
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ��,���ݻع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
					if(jsonData.info=='NoData'){
						Ext.Msg.show({title:'��ʾ',msg:'û�����ݸ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
				}
			},
			scope: this
		});
	}
 }	
 
 
  

