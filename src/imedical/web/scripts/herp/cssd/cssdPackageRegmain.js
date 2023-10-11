//定义控件的全局变量
/* var cycleIdCookieName="ThCycleDr";
var periodTypeNameCookieName="ThPeriodTypeName";
var periodTypeCookieName="ThPeriodType";
var periodCookieName="ThPeriod";
var LabelIdCookieName="ThLabelDr";
var kpiIdCookieName="ThKpiDr";
var nameStr=cycleIdCookieName+"^"+periodTypeNameCookieName+"^"+periodTypeCookieName+"^"+periodCookieName+"^"+LabelIdCookieName+"^"+kpiIdCookieName;
var dataStr="";
var data="";
var data1=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
var data3=[['1','1~6上半年'],['2','7~12下半年']];
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
	fieldLabel:'年度',
	width:180,
	listWidth : 180,
	allowBlank: false,
	//store: cycleDs,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
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
	fieldLabel: '期间类型',
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

//加载页面时渲染控件
/*
setComboValueFromClientOfNotChange(PaadmFileld,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//加载页面时渲染控件
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
	fieldLabel: '当前方案',
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
	　/* listeners : {
　　specialkey : function(field, event) { //监听specialkey 事件
　　if (event.getKey() == event.ENTER) { //当条件成立时，表明是enter键
　　 alert(222);
　　}
}
	} */
});
Ext.getCmp('Label').focus(false, 100);
//期间类别与方案查询的二级联动控制
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
	//KPI指标
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
        method: 'POST',// 请求方式  
        url: 'cssd.registerpackageexe.csp',//URL   
        params: {areaName:""+Adm+"",action:"getadminfo"},//要传递的参数，此参数可以是一组参数  
        waitMsg: '数据更新中，请稍后...',  
        success: function(response,options){  
            var textDoc = response.responseText;//注意此处用的是 responseText   
			//alert(textDoc);
            if(textDoc!=null)  
            {  
                var vs = textDoc.split('^'); 
				Ext.getCmp('RegNoFileld').setValue(vs[0]);
			Ext.getCmp('PaadmFileld').setValue(Adm);
			Ext.getCmp('LocFileld').setValue(vs[2]);
			Ext.getCmp('PationField').setValue(vs[1]);
		 Ext.getCmp('Label').focus(false, 100);
                //document.getElementById("zcl").innerHTML = vs[0];//将得到的值展示在页面上  
                //document.getElementById("zyc").innerHTML = vs[1];  
            }  
        },  
        failure: function(response,options){  
            Ext.Msg.alert("信息提示", "获取数据库数据出错,请稍后再试！");  
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
	title:'消毒包登记',
	region:'north',
	frame:true,
	height:90,
	items:[{
		xtype: 'panel',
		layout:"column",
		hideLabel:true,
		isFormField:true,
		items:[
				{columnWidth:.09,xtype:'label',text: '登记号:'},
				RegNoFileld,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.1,xtype:'label',text: '就诊号:'},
				PaadmFileld,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.09,xtype:'label',text: '科室:'},
				LocFileld,
				{columnWidth:.02,xtype:'displayfield'},
				{columnWidth:.09,xtype:'label',text: '病人:'},
				PationField
			]
	
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
			{columnWidth:.05,xtype:'label',text: '标签:'},
			Label,
			{columnWidth:.02,xtype:'displayfield'},
	
			/* {columnWidth:.05,xtype:'button',text: '查询',name: 'bc',tooltip: '查询',handler:function(){find()},iconCls: 'add'}, */
			{columnWidth:.01,xtype:'displayfield'},
			{columnWidth:.05,xtype:'button',text: '删除',name: 'bc',tooltip: '删除',handler:function(){think()},iconCls: 'add'}
			]
		}
	]
});

//查询按钮处理函数
find = function(){
	
	/* var cycleDr=Ext.getCmp('RegNoFileld').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodId=Ext.getCmp('LocFileld').getValue();
	if((periodId=="")||(periodId=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var LabelDr=Ext.getCmp('Label').getValue();
	if((LabelDr=="")||(LabelDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var kpiDr=Ext.getCmp('PationField').getValue();
	if((kpiDr=="")||(kpiDr=="null")){
		Ext.Msg.show({title:'注意',msg:'请选择指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	
	var periodType=Ext.getCmp('PaadmFileld').getValue();
	var periodTypeName=Ext.getCmp('PaadmFileld').getRawValue();
	
	
	vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,cycleDr:cycleDr,LabelDr:LabelDr,kpiDr:kpiDr,periodId:periodId}});
	
	dataStr=cycleIdCookieName+"^"+cycleDr+"!"+LabelIdCookieName+"^"+LabelDr+"!"+periodCookieName+"^"+periodId+"!"+kpiIdCookieName+"^"+kpiDr+"!"+periodTypeNameCookieName+"^"+periodTypeName+"!"+periodTypeCookieName+"^"+periodType;
	setBathCookieValue(dataStr); */
}

var pagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: vouchDetailST,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
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
		header: '登记号',
		dataIndex: 'RegNo',
		width: 150,
		align: 'left',
		sortable: false
    },{
		header: '病人',
		dataIndex: 'PatName',
		width: 150,
		align: 'right',
		//renderer:format,
		sortable: false
    },{
		header: '科室',
		dataIndex: 'PatLoc',
		width: 150,
		align: 'right',
		//renderer:format,
		sortable: false
    },{
		header: '标签',
		dataIndex: 'label',
		width: 150,
		align: 'right',
		//renderer:format,
		sortable: false
    },{
        header: '包名',
        dataIndex: 'packageName',
        width: 150,
        align: 'left',
        sortable: false
		
    },{
        header: '操作人',
        dataIndex: 'CountNurseDr',
        width: 150,
        align: 'left',
        sortable: false,
		editor:new Ext.form.TextField({
			allowBlank:true
		})
    },{
        header: '时间',
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
        header: '审核人',
        dataIndex: 'estAUserName',
        width: 70,
        align: 'center',
        sortable: true
    },{
		header: "审核时间",
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
//获取被点击的cell列id
autohisoutmedvouchMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	point=columnIndex;
})
*/

//点评按钮处理函数
Reg=function()
{
	var label=Ext.getCmp('Label').getValue();
	if(Adm==""||Adm==null)
	{
		Ext.Msg.show({title:'注意',msg:'请选择病人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	Ext.Ajax.request({
			url:'../csp/cssd.registerpackageexe.csp?action=Reg&Label='+label+'&Adm='+Adm+'&userdr='+userdr,
			waitMsg:'刷新中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					//Ext.Msg.show({title:'注意',msg:'点评成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,Adm:Adm}});
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'提示',msg:'重复登记!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='5'){
						Ext.Msg.show({title:'提示',msg:'消毒包过期!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='3'){
						Ext.Msg.show({title:'提示',msg:'错误的标签号!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='4'){
						Ext.Msg.show({title:'提示',msg:'消毒包标签没有灭菌!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='6'){
						Ext.Msg.show({title:'提示',msg:'消毒包标签没有发放!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
								 Ext.getCmp('Label').focus(false, 100);
						return;
					}
					if(jsonData.info=='7'){
						Ext.Msg.show({title:'提示',msg:'消毒包已被召回!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250,fn:focusReg});
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
		Ext.Msg.show({title:'提示',msg:'请选择要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
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
			waitMsg:'刷新中...',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					vouchDetailST.load({params:{start:0, limit:pagingToolbar.pageSize,Adm:Adm}});
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'提示',msg:'删除失败,数据回滚!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
					if(jsonData.info=='NoData'){
						Ext.Msg.show({title:'提示',msg:'没有数据更新!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
				}
			},
			scope: this
		});
	}
 }	
 
 
  

