var LocJsonStore= new Ext.data.JsonStore({
	url: '../EPRservice.Quality.MonthRepot.cls?action=getLoc',
	root: 'data',
    totalProperty: 'totalCount',
    fields: [
    	{ name: 'LocID' },	
        { name: 'Loc' }
    ]
	});	
LocJsonStore.load();

var doctorJsonStore= new Ext.data.JsonStore({
	url: '../EPRservice.Quality.MonthRepot.cls?action=getDoctor',
	root: 'data',
    totalProperty: 'totalCount',
    fields: [
    	{ name: 'UserID' },	
        { name: 'UserDesc' }
    ]
	});	
doctorJsonStore.load();

//ҳü
var headerPanel=new Ext.Panel({
    renderTo: Ext.getBody(),
    border : true,
	bodyStyle:'border-width: 0 0 1px 0;border-style: solid;border-color: #c0c0c0',
    floating: false,//true
    frame: false,//Բ�Ǳ߿�
    id:'header',
	layout:'absolute',
	style:'font-size:13px',
    height:120,
    width:768,
	items: 
	[{
   		xtype: "label",
		labelAlign: 'right',
		x: 200,
        y: 10,
        style:'font-size:22px;margin-top:10px;font-family:�����п�',  
        text: "������ͨ��ѧ��ǻҽԺ��ĩ�����ʿ���С��"
    	},
   		{xtype: "label",
		labelAlign: 'right',
        style:'font-size:13px',
        x: 60,
        y: 60,  
        text: "��  ��:"
        }, 
        {
		width:125,
		id:"RecordLoc",
		x: 115,
        y: 56, 
		resizable: false,
		xtype :'combo',
		valueField:'returnValue',
		displayField:'displayText',
		emptyText: "--��ѡ��--",
		//readOnly: true,
		triggerAction : 'all', 
		style:'font-size:13px',   
		mode: 'local',
		store: LocJsonStore,
		autoLoad : true,
		displayField: "Loc",  //value:CTLOCID,
		hiddenField:CTLOCID,
		valueField: "LocID"
   		},
   		{
   		xtype: "label",
		labelAlign: 'right',
		x: 320,
        y: 60, 
        style:'font-size:13px;',  
        text: "�����:"
        }, 
        {
		width:125,
		id:"doctor",
		x: 370,
        y: 35, 
		resizable: false,
		xtype :'combo',
		background:'#FFFFF0',
		valueField:'returnValue',
		displayField:'displayText',
		emptyText: "--��ѡ��--",
		//readOnly: true,
		triggerAction : 'all', 
		style:'font-size:13px',   
		mode: 'local',
		store: doctorJsonStore,
		autoLoad : true,
		displayField: "UserDesc",  //value:CTLOCID,
		valueField: "UserID"
   		},
   		{
   		xtype: "label",
        forId: "date",
		labelAlign: 'right',
        style:'font-size:13px;', 
        x: 600,
        y: 60,  
        text: "����:"
        }, 
        {
        name: "RecordDate", 
		style:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: 0px;',
        id:"RecordDate",
        xtype: "datefield",
        format :"Y-m",
        x: 645,
        y: 17, 
        style:'font-size:13px',
        value:new Date(), 
        width:125
   		},
		{
		xtype : 'button',
		id:'search',
		text : '��ѯ',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/btnSearch.gif',
		style : 'margin-left:638px;margin-top:90px;color:#FFC0CB;font-family:����;font-size:16px;',
		cls: 'x-btn-text-icon',
		listeners:{
			click: function ()
					{
						Search();
					}
				}
		},
		{
		xtype : 'button',
		id:'print',
		text : '��ӡ',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/printer.gif',
		style : 'margin-left:708px;margin-top:90px;color:#FFC0CB;font-family:����;font-size:16px;',
		cls: 'x-btn-text-icon',
		listeners:{
		click: function ()
					{
						Print();
					}
				}
			}]
        })


//ҳ������
var mainPanel=new Ext.Panel({
    renderTo: Ext.getBody(),
    floating: false,//true
    frame: false,//Բ�Ǳ߿�
    id:'main',
     border : true,

	bodyStyle:'border-width: 0 0 1px 0;border-style: solid;border-color: #c0c0c0;',
	layout:'absolute',
	style:'font-size:13px',
    width:768,
    height:600,
	items: 
	[ 
		{xtype: "label",
		labelAlign: 'right',
        style:'font-size:13px',
        x: 60,
        y: 14,  
        text: "���Ĳ���  ________________  ��"
        }, 
        {
        id:"Allcount",
        xtype: "textfield",
        style:'font-size:13px',
		x: 115,
        y: 10, 
        width:120
   		},
   		{xtype: "label",
		labelAlign: 'right',
        style:'font-size:13px',
        x: 60,
        y: 50,  
        text: "�Ҽ�����  ________________  ��"
        }, 
        {
        id:"GradeB",
        xtype: "textfield",
        style:'font-size:13px',
		x: 115,
        y: 47, 
        width:120
   		},
   		{xtype: "label",
		labelAlign: 'right',
        style:'font-size:13px',
        x: 590,
        y: 14,  
        text: "�׼��� ________________ %"
        }, 
        {
        id:"GradeAPercent",
        xtype: "textfield",
        style:'font-size:13px',
		x: 635,
        y: 10, 
        width:120
   		},
   		{xtype: "label",
		labelAlign: 'right',
        style:'font-size:13px',
        x: 577,
        y: 50,  
        text: "��������  ________________  ��"
        }, 
        {
        id:"GradeC",
        xtype: "textfield",
        style:'font-size:13px',
		x: 635,
        y: 47, 
        width:120
   		},
   		{xtype: "label",
		labelAlign: 'right',
        style:'font-size:13px',
        x: 20,
        y: 100,  
        width:20,
        text: "��ҳ��д��������"
        }, 
        {
        id:"MedicalRecord",
        xtype: "textarea",
        style:'font-size:13px',
		x: 60,
        y: 85, 
        width:712,
        height: 150
   		},
   		{
   		xtype: "label",
		labelAlign: 'right',
		x: 20,
        y: 250, 
        width:20,
        style:'font-size:13px;',  
        text: "���̼�¼��������"
        }, 
        {
        id:"DailyRecord",
        xtype: "textarea",
        style:'font-size:13px',
		x: 60,
        y: 235, 
        width:712,
        height: 150
   		},
   		{
   		xtype: "label",
        forId: "RecordDate",
		labelAlign: 'right',
        style:'font-size:13px;', 
        x: 20,
        y: 430,  
        width:20,
        text: "�Ľ����"
        }, 
        {
		//style:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: #000000 10px solid;',
        id:"Opinion",
        xtype: "textarea",
        x: 60,
        y: 385, 
        style:'font-size:13px',
        width:712,
        height: 150
   		},
		{
		xtype : 'button',
		text : '����',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/btnAddCondition.gif',
		style : 'margin-left:360px;margin-top:560px;color:#FFC0CB;font-family:����;font-size:16px;',
		cls: 'x-btn-text-icon',
		listeners:{
			click: function ()
					{
						Save();
					}
				}
			}
   	]
})

///��װ���
var headerPanel=new Ext.Panel({
    renderTo: Ext.getBody(),
    floating: false,//true 
    frame: false,//Բ�Ǳ߿�
    id:'forViewport',
    layout:'form',
    bodyStyle:'padding:0px 0px 0px 0px',
     autoScroll:true,

	items: 
	[{  
        //title: '�ʿ��±�',  
        width: 772,
        height: 120,
		items:header,shim: false,collapsible: true,animCollapse: false,layout:'column',constrainHeader: true
     }, 
     {  
        title: '��ϸ',  
        width: 772,
		items:main,shim: false,collapsible: true,animCollapse: false,layout:'column',constrainHeader: true
     }]
})

function Save(){
	var RecordDateValue=(Ext.getCmp("RecordDate").getRawValue());
	if ((RecordDateValue=='')||(RecordDateValue==null))
	{
		alert("��ѡ���¼���ڣ�")
		return;
	}
	var RecordLocValue=(Ext.getCmp("RecordLoc").getValue());
	if ((RecordLocValue=='')||(RecordLocValue==null))
	{
		alert("��ѡ����ң�")
		return;
	}
	var doctorValue=(Ext.getCmp("doctor").getValue());
	if ((doctorValue=='')||(doctorValue==null))
	{
		alert("��ѡ�����ߣ�")
		return;
	}
	var AllcountValue=(Ext.getCmp("Allcount").getRawValue());
	var AllcountValue=AllcountValue.replace(/\^/g, ';UPTIP');
	var GradeBValue=(Ext.getCmp("GradeB").getRawValue());
	var GradeBValue=GradeBValue.replace(/\^/g, ';UPTIP');
	var GradeCValue=(Ext.getCmp("GradeC").getRawValue());
	var GradeCValue=GradeCValue.replace(/\^/g, ';UPTIP');
	var GradeAPercentValue=(Ext.getCmp("GradeAPercent").getRawValue());
	var GradeAPercentValue=GradeAPercentValue.replace(/\^/g, ';UPTIP');
	var MedicalRecordValue=(Ext.getCmp("MedicalRecord").getRawValue());
	var MedicalRecordValue=MedicalRecordValue.replace(/\^/g, ';UPTIP');
	var DailyRecordValue=(Ext.getCmp("DailyRecord").getRawValue());
	var DailyRecordValue=DailyRecordValue.replace(/\^/g, ';UPTIP');
	var OpinionValue=(Ext.getCmp("Opinion").getRawValue());
	var OpinionValue=OpinionValue.replace(/\^/g, ';UPTIP');
	
	
	var data=AllcountValue+"^"+GradeBValue+"^"+GradeCValue+"^"+GradeAPercentValue+"^"+MedicalRecordValue+"^"+DailyRecordValue+"^"+OpinionValue+"^"+RecordDateValue+"^"+RecordLocValue+"^"+doctorValue
    //alert(data)
    Ext.Ajax.request({
	    
		url: '../EPRservice.Quality.MonthRepot.cls',
		timeout: 5000,
		method: 'POST',
		params: 
			{	
				action:"save",
				data:data
			},
		success:function(response,option){
			alert("����ɹ���");
		},
		failure:function(response,option){
			alert("����ʧ�ܣ�");
		}
	});	
    return;
	}
	
	
function Print()
{	
	Save();
	var RecordDateValue=(Ext.getCmp("RecordDate").getRawValue());
	var RecordLocValue=(Ext.getCmp("RecordLoc").getRawValue());
	var doctorValue=(Ext.getCmp("doctor").getRawValue());
	var AllcountValue=(Ext.getCmp("Allcount").getRawValue());
	var GradeBValue=(Ext.getCmp("GradeB").getRawValue());
	var GradeCValue=(Ext.getCmp("GradeC").getRawValue());
	var GradeAPercentValue=(Ext.getCmp("GradeAPercent").getRawValue());
	var MedicalRecordValue=(Ext.getCmp("MedicalRecord").getRawValue());
	var DailyRecordValue=(Ext.getCmp("DailyRecord").getRawValue());
	var OpinionValue=(Ext.getCmp("Opinion").getRawValue());
	
	//Excel��ӡ
	path="http://192.168.2.45/dthealth/med/Results/Template/"
    fileName=path+"EPRMonthReport.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName)
	xlsSheet = xlsBook.ActiveSheet
	xlsSheet.cells(3,2)=RecordLocValue
	xlsSheet.cells(3,6)=doctorValue
	xlsSheet.cells(3,9)=RecordDateValue
	xlsSheet.cells(4,2)=AllcountValue
	xlsSheet.cells(4,9)=GradeAPercentValue
	xlsSheet.cells(5,2)=GradeBValue
	xlsSheet.cells(5,9)=GradeCValue
	xlsSheet.cells(6,2)=MedicalRecordValue
	xlsSheet.cells(14,2)=DailyRecordValue
	xlsSheet.cells(22,2)=OpinionValue
	xlsSheet.PrintOut();
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;


}




function Search(){
	var RecordDateValue=(Ext.getCmp("RecordDate").getRawValue());
	if ((RecordDateValue=='')||(RecordDateValue==null))
	{
		alert("��ѡ���¼���ڣ�")
		return;
	}
	var RecordLocValue=(Ext.getCmp("RecordLoc").getValue());
	if ((RecordLocValue=='')||(RecordLocValue==null))
	{
		alert("��ѡ����ң�")
		return;
	}
	var doctorValue=(Ext.getCmp("doctor").getValue());
	if ((doctorValue=='')||(doctorValue==null))
	{
		alert("��ѡ�����ߣ�")
		return;
	}
	/*var AllcountValue=(Ext.getCmp("Allcount").getRawValue());
	var AllcountValue=AllcountValue.replace(/\^/g, ';UPTIP');
	var GradeBValue=(Ext.getCmp("GradeB").getRawValue());
	var GradeBValue=GradeBValue.replace(/\^/g, ';UPTIP');
	var GradeCValue=(Ext.getCmp("GradeC").getRawValue());
	var GradeCValue=GradeCValue.replace(/\^/g, ';UPTIP');
	var GradeAPercentValue=(Ext.getCmp("GradeAPercent").getRawValue());
	var GradeAPercentValue=GradeAPercentValue.replace(/\^/g, ';UPTIP');
	var MedicalRecordValue=(Ext.getCmp("MedicalRecord").getRawValue());
	var MedicalRecordValue=MedicalRecordValue.replace(/\^/g, ';UPTIP');
	var DailyRecordValue=(Ext.getCmp("DailyRecord").getRawValue());
	var DailyRecordValue=DailyRecordValue.replace(/\^/g, ';UPTIP');
	var OpinionValue=(Ext.getCmp("Opinion").getRawValue());
	var OpinionValue=OpinionValue.replace(/\^/g, ';UPTIP');
	
	
	var data=AllcountValue+"^"+GradeBValue+"^"+GradeCValue+"^"+GradeAPercentValue+"^"+MedicalRecordValue+"^"+DailyRecordValue+"^"+OpinionValue+"^"+RecordDateValue+"^"+RecordLocValue+"^"+doctorValue
    alert(data)*/
    var data=RecordDateValue+"^"+RecordLocValue+"^"+doctorValue
    Ext.Ajax.request({
	    
		url: '../EPRservice.Quality.MonthRepot.cls',
		timeout: 5000,
		method: 'POST',
		params: 
			{	
				action:"search",
				data:data
			},
		success:function(response,option){
			var value=response.responseText; 
			var arr=value.split("^"); 
			Ext.getCmp("Allcount").setValue(arr[0].replace(';UPTIP','^'));
			Ext.getCmp("GradeB").setValue(arr[3].replace(/;UPTIP/g,'^'));
			Ext.getCmp("GradeC").setValue(arr[4].replace(/;UPTIP/g,'^'));
			Ext.getCmp("GradeAPercent").setValue(arr[2].replace(/;UPTIP/g,'^'));
			Ext.getCmp("MedicalRecord").setValue(arr[5].replace(/;UPTIP/g,'^'));
			Ext.getCmp("DailyRecord").setValue(arr[1].replace(/;UPTIP/g,'^'));
			Ext.getCmp("Opinion").setValue(arr[6].replace(/;UPTIP/g,'^'));
		},
		failure:function(response,option){
			alert("��ѯʧ�ܣ�");
		}
	});	
    return;
	}

Ext.onReady(function(){  
new Ext.Viewport({
	id: 'patientListPort', 
	layout : 'border',
items:
	[
	//{items:button,shim: false,collapsible: true,animCollapse: false,layout:'fit',region : 'north',constrainHeader: true,height: 70},
	{items:forViewport,shim: false,collapsible: true,animCollapse: false,layout:'fit',region : 'center',constrainHeader: true}
	
	] 
});  
});
