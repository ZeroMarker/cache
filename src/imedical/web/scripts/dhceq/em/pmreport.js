var editIndex;
var Columns=getCurColumnsInfo('EM.G.PMReportList','','','')
var GlobalObj = {
	TemplatePath:"",
	MaintDR:"",
	MTType:"",
	PMReportDR:"",
	EquipInfo:"",
	MaintDate:"",
	Status:"",
	CPMTemplateDR:"",
	CPMTemplate:"",
	GetValue : function()
	{
		this.TemplatePath = getElementValue("TemplatePath")
		this.MaintDR = getElementValue("MaintDR")
		this.MTType = getElementValue("MTType")
		this.PMReportDR = getElementValue("PMReportDR")
		this.EquipInfo = getElementValue("EquipInfo")
		this.MaintDate = getElementValue("vMaintDate")
		this.Status = getElementValue("Status")
		this.CPMTemplateDR= getElementValue("CPMTemplateDR")
	}
}

jQuery(document).ready(function()
{
	initDocument();
	
});

/*****************************************��ʼ��******************************************/
function initDocument()
{
	GlobalObj.GetValue()
	initLookUp()
	jQuery('#BUpdate').bind('click', BUpdateHandle)
	jQuery('#BSubmit').bind('click', BSubmitHandle)
	jQuery('#BPrint').bind('click',BPrint_Clicked)
	initButtonWidth()
	initEquipData()
	initUserInfo();
	initPMReportData()
	initDataGrid()
	//add by csj 2020-03-02 �����:1204616
	if(GlobalObj.Status==""||GlobalObj.Status!=0){
		disableElement("BSubmit",true)	
	}
	//add by csj 2020-03-13 �����:1226167
	if(document.getElementById("ReadOnly").value==1){
	    disableElement("BUpdate",true)
	    disableElement("BSubmit",true)
	    disableElement("BPrint",true)
		disableElement('CPMTemplate',true)
		disableElement("BAddRow",true);
		disableElement("BDeleteRow",true);
	}
}
function initEquipData()
{
	var Equiplist=GlobalObj.EquipInfo.split("^")
	var sort=95
	setElement("EquipName",Equiplist[0])
	setElement("Model",Equiplist[sort+0])
	setElement("No",Equiplist[70])
	setElement("MaintDate",GlobalObj.MaintDate)
}

function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="CPMTemplate") {
		GlobalObj.CPMTemplateDR=CurValue;
		SaveFromPMTemplate();
	}
}

function SaveFromPMTemplate()
{
	if (GlobalObj.CPMTemplateDR=="") return
	var PMReportData=GlobalObj.PMReportDR+"^"+GlobalObj.CPMTemplateDR+"^"+GlobalObj.MaintDR+"^"+getElementValue('Caption')+"^"+getElementValue('Note')+"^"+getElementValue('PreState')+"^"+getElementValue('State')+"^"+getElementValue('Remark')
	jQuery.ajax({
        url :"dhceq.jquery.method.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQ.Process.DHCEQPMReport",
            MethodName:"SaveFromPMTemplate",
            Arg1:PMReportData,
            Arg2:GlobalObj.CPMTemplateDR,
            Arg3:0,
            ArgCnt:3
        },
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
        error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
        success:function (data, response, status) {
            jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			GlobalObj.PMReportDR=data
            if (data >=0) {
        		editIndex=undefined
	        	initPMReportData()
				initDataGrid()
	   			jQuery.messager.show({
                		title: '��ʾ',
               			msg: '������ϣ�'
            	});
        	}   
        	else {
           		jQuery.messager.alert('����ʧ�ܣ�',data, 'warning')
           		return;
           	}
    	}
    })
	
}

function initPMReportData()
{
	if (GlobalObj.PMReportDR=="") return
	jQuery.ajax({
    	async: false,
		url :"dhceq.jquery.method.csp",
		type:"POST",
		data:{
		    ClassName:"web.DHCEQ.Process.DHCEQPMReport",
		    MethodName:"GetPMTemplate",
		    Arg1:GlobalObj.PMReportDR,
		    ArgCnt:1
		},
		success:function (data, response, status) {
	    	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var PMReportData=data.split("^");
	    	var sort=26
	    	GlobalObj.CPMTemplateDR=PMReportData[0]
			setElement("CPMTemplate",PMReportData[sort+0]);
	    	setElement('Caption',PMReportData[2])
	    	setElement('Note',PMReportData[3])
	    	setElement('PreState',PMReportData[4])
	    	setElement('State',PMReportData[5])
	    	setElement('Remark',PMReportData[6])
	    	GlobalObj.Status=PMReportData[7]
	    	var panel = $("#tPMReport").datagrid("getPanel");
	    	
	    	if(GlobalObj.Status>0) {
	        	disableElement("BUpdate",true)
	        	disableElement("BSubmit",true)
//	        	disableElement("BPrint",true)
	        	disableElement("CPMTemplate",true)
//	        	$('#BAddRow').linkbutton("disable");
//	        	$('#BDeleteRow').linkbutton("disable");
	        	panel.find("#BAddRow").hide()
				panel.find("#BDeleteRow").hide()
	    	}
	    	else if(document.getElementById("ReadOnly").value==1){
	        	disableElement("BUpdate",true)
	        	disableElement("BSubmit",true)
	        	disableElement("BPrint",true)
	    		disableElement('CPMTemplate',false)
	        }
	    	else{
		        disableElement("BPrint",false) 
	    	}
	    	//add by csj 2020-03-02 �����:1204616
	    	if(GlobalObj.Status==0){
		    	disableElement("BSubmit",false)
		    }
		 }
	})
}
function BAddHandle()
{
	if(editIndex>="0"){
		jQuery("#tPMReport").datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
	var rows = $("#tPMReport").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    if(lastIndex==-1) 
    {
	    jQuery("#tPMReport").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		return
	}
    var TMaintItemDR = (typeof rows[lastIndex].TMaintItemDR == 'undefined') ? "" : rows[lastIndex].TMaintItemDR;
    if (TMaintItemDR=="")
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	    return
	}
	jQuery("#tPMReport").datagrid('insertRow', {index:newIndex,row:{}});
	editIndex=0;
}
function BUpdateHandle()
{
	endEditing();
	var effectRow = new Object();
	if (GlobalObj.Status==0)
    {
	    var type=0
    
	    //IE�³��ְ�json����תΪjson�����ı��unicode�����⣬��󾭹��Ų飬������IE8����JSON.stringify()�����
		var temp=jQuery('#tPMReport').datagrid('getRows')
	    effectRow["data"]=JSON.stringify(temp)
	    eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
	}
	else if (GlobalObj.Status==1)
	{
		var type=1
		effectRow.data=""
	}
    var PMReportData=GlobalObj.PMReportDR+"^"+GlobalObj.CPMTemplateDR+"^"+GlobalObj.MaintDR+"^"+getElementValue('Caption')+"^"+getElementValue('Note')+"^"+getElementValue('PreState')+"^"+getElementValue('State')+"^"+getElementValue('Remark')
    jQuery.ajax({
        url :"dhceq.jquery.method.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQ.Process.DHCEQPMReportList",
            MethodName:"SaveAllData",
            Arg1:PMReportData,
            Arg2:effectRow.data,
            Arg3:type,
            ArgCnt:3
         },
         success:function (data, response, status) {
	         
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
	        if(data>0){
		        GlobalObj.PMReportDR=data
		        SelectedIndex=-1;
            	preIndex=-1;
            	editIndex=undefined
		        initPMReportData()
   				initDataGrid()
	   			jQuery.messager.show({
                		title: '��ʾ',
               			msg: GlobalObj.Status=='1'?'�ύ��ϣ�':'������ϣ�'
            	});
   			}
   			else
   			{
	   			jQuery.messager.show({
                		title: '��ʾ',
               			msg: data
            	});
   			}
          }
    })
}
function BSubmitHandle()
{
	GlobalObj.Status=1
	BUpdateHandle()
}
//add by wl 2019-11-20 WL0013
function BPrint_Clicked()
{
	var PrintFlag=getElementValue("PrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	var PreviewRptFlag=getElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var PMReportDR=getElementValue("PMReportDR");
	if (PMReportDR=="")
	{ 
		return;
	} 
	var HOSPDESC = curSSHospitalName;
	var filename="";
	if(PrintFlag==0)
	{
		MakeExcel();
	}
	if(PrintFlag==1)
	{ 
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQPMReport.raq(ReportDR="+PMReportDR
		    +";HOSPDESC="+HOSPDESC
		    +";curUserName="+curUserName
		    +")}";
	        DHCCPM_RQDirectPrint(fileName);		
		}
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQPMReport.raq&ReportDR="+PMReportDR
		    +"&HOSPDESC="+HOSPDESC
		    +"&curUserName="+curUserName
			DHCCPM_RQPrint(fileName);
		}
	}
}
function MakeExcel()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		MakeExcelChrome()
	}
	else
	{
		MakeExcelIE()
	}
}
function MakeExcelChrome()
{
	var pmtemplatedata;
	var Equiplist=GlobalObj.EquipInfo.split("^")
	var sort=95
	jQuery.ajax({
	        url :"dhceq.jquery.csp",
	        type:"POST",
	        async: false,//ͬ������
	        data:{
	            ClassName:"web.DHCEQ.Process.DHCEQPMReportList",
	        	QueryName:"GetPMReportList",
	        	Arg1:GlobalObj.PMReportDR,
	        	ArgCnt:1
	         },
	         success:function (data, response, status) {
		        pmtemplatedata=jQuery.parseJSON(data);
		        pmtemplatedata.rows.sort(function(a,b){
	            return a.TMaintItemCatDR-b.TMaintItemCatDR})
	          }
	    })
	var DataInfo=JSON.stringify(pmtemplatedata.rows)
	var Template=GlobalObj.TemplatePath+"DHCEQPMReport.xls";
	
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="var Template='"+Template+"';";
	Str +="var xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add(Template);"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).value='"+Equiplist[0]+"';"; //EquipName
	Str +="xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).value='"+Equiplist[70]+"';"	//No
	Str +="xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(4,6)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).value='"+Equiplist[sort+0]+"';" //Model
	Str +="xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).value='"+Equiplist[9]+"';" //LeaveFactoryNo
	Str +="xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).value='"+Equiplist[sort+13]+"';" //�������� ManuFactory
	Str +="xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).value='"+Equiplist[43]+"';"	//�������� StartDate
	Str +="xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).value='"+Equiplist[sort+7]+"';"	//ʹ�ÿ��� UseLoc
	Str +="xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).value='"+GlobalObj.MaintDate+"';" //pm����  modify by lmm 2018-11-09 629135
	Str +="xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).Borders.Weight = 2;"
	Str +="var oldindex,oldvalue;"
	Str +="var total="+pmtemplatedata.total+";"
	Str +="for (var Row=0;Row<total;Row++){"
	Str +="var OneInfo="+DataInfo+";"
	Str +="if (oldvalue==undefined){"
	Str +="oldindex=Row;"
	Str +="oldvalue=OneInfo[Row].TMaintItemCatDR;}"
	Str +="else if (OneInfo[Row].TMaintItemCatDR!=oldvalue){"
	Str +="oldvalue=OneInfo[Row].TMaintItemCatDR;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).value=OneInfo[Row-1].TMaintItemCatDesc;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).Borders.Weight = 2;"
	Str +="oldindex=Row;"
	Str +="oldvalue=OneInfo[Row].TMaintItemCatDR;}"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).value=OneInfo[Row].TMaintItemDesc;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).value=OneInfo[Row].TResult;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).Borders.Weight = 2;}"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).value=OneInfo[total-1].TMaintItemCatDesc;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+8,1).value='������״'";
	Str +="xlsheet.Cells(total+8,1).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).value="+jQuery('#State').val()+";"
	Str +="xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+9,1).value='��ע';"	
	Str +="xlsheet.Cells(total+9,1).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).value="+jQuery('#Remark').val()+";"//��ע
	Str +="xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,1).value='pm��Ա';"	
	Str +="xlsheet.Cells(total+10,1).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,2).value='';"
	Str +="xlsheet.Cells(total+10,2).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,3).value='ʹ�ò���';"
	Str +="xlsheet.Cells(total+10,3).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,4).value='';"
	Str +="xlsheet.Cells(total+10,4).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,5).value='�������';"	
	Str +="xlsheet.Cells(total+10,5).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,6).value='';"	
	Str +="xlsheet.Cells(total+10,6).Borders.Weight = 2;"
	Str +="xlsheet.printout;"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlApp=null;"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;"
	Str +="return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 0;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
}
function MakeExcelIE()
{
	var pmtemplatedata
	var Equiplist=GlobalObj.EquipInfo.split("^")
	var sort=95
	jQuery.ajax({
	        url :"dhceq.jquery.csp",
	        type:"POST",
	        async: false,//ͬ������
	        data:{
	            ClassName:"web.DHCEQ.Process.DHCEQPMReportList",
	        	QueryName:"GetPMReportList",
	        	Arg1:GlobalObj.PMReportDR,
	        	ArgCnt:1
	         },
	         success:function (data, response, status) {
		         //JSON.parse( your_string );
		        pmtemplatedata=jQuery.parseJSON(data);
		        pmtemplatedata.rows.sort(function(a,b){
	            return a.TMaintItemCatDR-b.TMaintItemCatDR})
		         //eval("(" + str + ")");
	          }
	    })
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=GlobalObj.TemplatePath+"DHCEQPMReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");	    
	    for (var i=0;i<=0;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).value=Equiplist[0]; //EquipName
     		xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).value=Equiplist[70];	//No
     		xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(4,6)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).value=Equiplist[sort+0]; //Model
     		xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).value=Equiplist[9]; //LeaveFactoryNo
     		xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).value=Equiplist[sort+13] //�������� ManuFactory
     		xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).value=Equiplist[43];	//�������� StartDate
     		xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).value=Equiplist[sort+7]	//ʹ�ÿ��� UseLoc
     		xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).value=GlobalObj.MaintDate //pm����  modify by lmm 2018-11-09 629135
     		xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).Borders.Weight = 2;
	    	//xlsheet.cells(row,8)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"; 
	    	var oldindex,oldvalue	 
	    	var total=pmtemplatedata.total
	    	for (var Row=0;Row<total;Row++)
			{
				
				if(oldvalue==undefined)
				{
					oldindex=Row
     			 	oldvalue=pmtemplatedata.rows[Row].TMaintItemCatDR
				}
				else if(pmtemplatedata.rows[Row].TMaintItemCatDR!=oldvalue)
				{
					oldvalue=pmtemplatedata.rows[Row].TMaintItemCatDR
					xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).mergecells=true;
     			 	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).value=pmtemplatedata.rows[Row-1].TMaintItemCatDesc;
     			 	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).Borders.Weight = 2;
     			 	oldindex=Row
     			 	oldvalue=pmtemplatedata.rows[Row].TMaintItemCatDR
     			 	
				}
				else
				{
				}
						
				 xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).mergecells=true;
     			 xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).value=pmtemplatedata.rows[Row].TMaintItemDesc;
     			 xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).Borders.Weight = 2;
     			 xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).mergecells=true;
     			 xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).value=pmtemplatedata.rows[Row].TResult;	
     			 xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).Borders.Weight = 2;			
	    	}
	    	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).value=pmtemplatedata.rows[total-1].TMaintItemCatDesc;
     		xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).Borders.Weight = 2;
     			 	
			xlsheet.Cells(total+8,1).value="������״";	
     		xlsheet.Cells(total+8,1).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).value=jQuery('#State').val();
     		xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).Borders.Weight = 2;
     		xlsheet.Cells(total+9,1).value="��ע";	
     		 xlsheet.Cells(total+9,1).Borders.Weight = 2;
     		  xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).value=jQuery('#Remark').val();//��ע
     		xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).Borders.Weight = 2;
     		xlsheet.Cells(total+10,1).value="pm��Ա";	
     		 xlsheet.Cells(total+10,1).Borders.Weight = 2;
     		 xlsheet.Cells(total+10,2).value="";	
     		 xlsheet.Cells(total+10,2).Borders.Weight = 2;
     		 xlsheet.Cells(total+10,3).value="ʹ�ò���";	
     		 xlsheet.Cells(total+10,3).Borders.Weight = 2;
     		 xlsheet.Cells(total+10,4).value="";	
     		 xlsheet.Cells(total+10,4).Borders.Weight = 2;
     		 xlsheet.Cells(total+10,5).value="�������";	
     		 xlsheet.Cells(total+10,5).Borders.Weight = 2;
     		 xlsheet.Cells(total+10,6).value="";	
     		 xlsheet.Cells(total+10,6).Borders.Weight = 2;
     		
     			 	
	    xlsheet.printout; //��ӡ���
	    //xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}	
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="CPMTemplate")
	{
		setElement("CPMTemplateDR",rowData.TRowID)
		setElement("CPMTemplate",rowData.TName)
		GlobalObj.CPMTemplateDR=rowData.TRowID;
		SaveFromPMTemplate();
	}
	
}

function clearData(elementID)
{
	setElement(elementID+"DR",'')
	return;
}

function initDataGrid()
{
	$HUI.datagrid("#tPMReport",{
	url:$URL,
    queryParams:{
        ClassName:"web.DHCEQ.Process.DHCEQPMReportList",
        QueryName:"GetPMReportList",
        ReportDR:GlobalObj.PMReportDR,
    },
    border:true,
    fit:true,
    fitColumns:true,   //add by lmm 2020-06-05 UI
    singleSelect:true,
    rownumbers: true,  //���Ϊtrue������ʾһ���к���
//    sortName:'TMaintItemCatDesc',	//modified by csj 2020-02-17 ����ţ�1192297
    toolbar:[{
	     		id:"BAddRow",
                text : "����",
                iconCls : "icon-add",
                handler : BAddHandle
            },{
	            id:"BDeleteRow",
	            text : "ɾ��",
	            iconCls : "icon-remove",
	            handler : function() {
	             	var row = jQuery('#tPMReport').datagrid('getSelected');
	                if (row) {
						messageShow("confirm","","","�Ƿ�ɾ��ѡ�б�����ϸ?","",function () {
							var rowIndex = jQuery('#tPMReport').datagrid('getRowIndex', row);
		                    jQuery('#tPMReport').datagrid('deleteRow', rowIndex);
		                    SelectedIndex=-1;
							preIndex=-1;
							editIndex=undefined;
						},function () {return})
	                }
					else
					{
						messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
					}
	            }
	         }
            ],
    columns:Columns,
    onDblClickRow : function (rowIndex, rowData) {
		var Status=getElementValue("Status");
		if (Status>0) return;
		if (editIndex!=rowIndex)
		{
			if (endEditing())
			{
				$('#tPMReport').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
				editIndex = rowIndex;
			} else {
				$('#tPMReport').datagrid('selectRow', editIndex);
			}
		}
		else
		{
			endEditing();
		}
    },
    onLoadSuccess:function(){
    	if(GlobalObj.Status>0) {
	    	disableElement("BAddRow",true);
			disableElement("BDeleteRow",true);
    	}
	},
    pagination:false, //modified by csj 2020-04-14 ����ҳ
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50]   
});
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#tPMReport').datagrid('validateRow', editIndex))
	{
		$('#tPMReport').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
