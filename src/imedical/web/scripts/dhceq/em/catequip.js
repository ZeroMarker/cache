//�������
var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 �޸�ҳ�治��ʾ�����
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 �޸�ҳ�治��ʾ�����

jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

//add by lmm 2019-09-01 988161
var GlobalObj = {
	ID : "0",
	Job: ""	//add by csj 2020-02-24
}

function initDocument()
{
	initUserInfo(); //Modified By QW20210422 bug:QW0100 ��ʼ��
	GlobalObj.Job=getElementValue("Job");	//add by csj 2020-02-24
	defindTitleStyle();
	initDHCEQEquipList();			//��ʼ�����	
	initTree();  //��ʼ����
//	ExpandTree(0); //��չ���ڵ� modified by csj 2020-02-24
}
//modified by csj 2020-02-24
function initTree()
{
	//modified by czf 2021-02-25 begin 1959169
	//var EquipeCatTree =tkMakeServerCall("web.DHCEQ.Plat.LIBTree","GetEquipeCatTreeStr")
	var EquipeCatTree=$.m({
	    ClassName:"web.DHCEQ.Plat.LIBTree",
	    MethodName:"GetEquipeCatTreeStr",
	},false);
	//modified by czf 2021-02-25 end 1959169
	
	$('#tDHCEQCEquipCatTree').tree({
		data:JSON.parse(EquipeCatTree),
		onClick: function (node) {
			NodeClickHandler(node)
		},
		lines:true,
	})
}
function initDHCEQEquipList()
{
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",   //Modefied by zc0044 2018-11-22 �޸�query����
	        QueryName:"GetEquipList",
	        Data:"^IsDisused=N^IsOut=N^IncludeFlag=1"+"^HospitalDR="+curHospitalID, //Modified By QW20210422 bug:QW0100 ����Ժ��
	        ReadOnly:1,
	        Ejob:GlobalObj.Job	//add by csj 2020-02-22 ����ţ�1190963
	    },
	    border:false,
		//striped:true,
	    cache:false,
	    //singleSelect:true,
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
    	frozenColumns:frozencolumns,
		fit:true,
    	pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
    	toolbar:[{
                iconCls: 'icon-export',
                text:'����',
                handler: function(){
                     BSaveExcel_Click();
                }},
                {
                iconCls: 'icon-set-col',
                text:'����������',
                handler: function(){
                     BColSet_Click();
                }}],  
		onDblClickRow:function(rowIndex, rowData)
		{	
			if (rowData.TRowID!=""){
				var str="dhceq.em.equip.csp?&RowID="+rowData.TRowID+"&ReadOnly=1";
				//Modefied by zc 2018-12-21  zc0047 �޸ĵ�����ʾ��С
				showWindow(str,"̨����ϸ����","","","icon-w-paper","","","","verylarge");    //MZY0119	2568613		2022-04-07
				//Modefidy by zc0046 �޸ĵ����ڲ�ͬ�ֱ��ʵ�����������
			}
		},
		onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();		
		}
});
}
function InitToolbarForAmountInfo() {
	var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'EquipList','',GlobalObj.Job,''); 	// MZY0144	3074976,3076574,3077489,3079473		2022-11-24
	//var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',GlobalObj.Job);	//modified by csj 2020-02-22 ����ţ�1190963
	$("#sumTotal").html(Data);
	//var gridToolbar = $("#tDHCEQEquipListDiv .datagrid-toolbar table tr td:nth-child(4)  ");
	//gridToolbar.empty();
	//gridToolbar.append(Data);	
}
function BSaveExcel_Click() //����
{	
	//Modefied by zc0109 2021-12-02 begin ����̨�˵���
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		var Rows = $('#tDHCEQEquipList').datagrid('getRows');
		var RowCount=Rows.length;
		if(RowCount<=0){
			messageShow("","","","û������!")
			return;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQEquipExport.raq&CurTableName=Equip&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+getElementValue("Job")
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		var vData="^IsDisused=N^IsOut=N^EquipCatDR="+GlobalObj.ID+"^IncludeFlag=1"+"^HospitalDR="+curHospitalID  //Modified By QW20210422 bug:QW0100 ����Ժ��
		var Job=document.getElementById("Job");
		PrintDHCEQEquipNew("Equip",1,Job,vData,"",100);
		return
	}
	//Modefied by zc0109 2021-12-02 end ����̨�˵���
}
function BColSet_Click() //��������������
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)  //Modefidy by lmm 2020-06-02 UI
	
	//Modefidy by zc0046 �޸ĵ����ڲ�ͬ�ֱ��ʵ�����������
	//Modefied by zc0044 2018-11-22 �޸ĵ�����С
}
function NodeClick(id)
{
	var nod=new Node(id);	
	NodeClickHandler(nod);
}

function NodeClickHandler(nod)
{
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",		//Modefied by zc0044 2018-11-22 �޸�query����
	        QueryName:"GetEquipList",
	        Data:"^IsDisused=N^IsOut=N^EquipCatDR="+nod.id+"^IncludeFlag=1"+"^HospitalDR="+curHospitalID, //Modified By QW20210422 bug:QW0100 ����Ժ��
	        ReadOnly:1,
	        Ejob:GlobalObj.Job	//add by csj 2020-02-22 ����ţ�1190963
	    }, 
	     onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();
		}
	    });
	    
	 GlobalObj.ID=nod.id  //modified by csj 2020-02-24
	    
}
function ExpandTree(id)
{
	var nod=new Node(id);	
	if (nod.HasChild!="1") return;
	layer=parseInt(nod.Layer)+1;
	
	var child=document.getElementById("Child"+id);
	if (!child) return;
	var obj=document.getElementById("Loaded"+id);
	var data="";
	if (!obj) return;
	if (obj.value=="0")
	{data=LoadData(id,layer,GetPreLine(id));
	 obj.value="1";
	}
	else	{
		data=child.innerHTML;
	}
	var child=document.getElementById("Child"+id);
	if (!child) return;
	child.innerHTML=data;
	var expand=0;
	if (child.style.display=="none") expand=1;
	SetExpandIcon(id,nod.HasChild,expand);
}
function LoadData(id,layer,preline)
{
	var ids=tkMakeServerCall("web.DHCEQCEquipeCat","GetTreeNoteIds",id)
	if (ids=="") return "";
	var listid=ids.split("^");
	var i=listid.length;
	var data="";
	for (var j=0;j<i;j++)
	{
		data=data+tkMakeServerCall("web.DHCEQCEquipeCat","GetTreeNote",id,layer,preline,listid[j]);
	}
	return data;
}
function GetParentLine(id,linehtml)
{	
	var parid=getElementValue("Parent"+id);
	if (parid==""||parid==0)
	{
		if (!document.getElementById("Link"+parid)) return linehtml;
	}
	if (getElementValue("IsLast"+id)=="0"){
		if (linehtml=="")
		{linehtml="4";}
		else
		{linehtml="4^"+linehtml;}
	}
	else	{
		if (linehtml=="")
		{linehtml="5";}
		else
		{linehtml="5^"+linehtml;}
	}	
	return GetParentLine(parid,linehtml)
}


function GetPreLine(id)
{	
	return GetParentLine(id,"");
}

function Node(id)
{
	this.IsLast=getElementValue("IsLast"+id);
	this.Parent=getElementValue("Parent"+id);
	this.Loaded=getElementValue("Loaded"+id);
	this.Layer=getElementValue("Layer"+id);
	this.HasChild=getElementValue("HasChild"+id);
	this.ID=getElementValue("ID"+id);
	this.Text=getElementValue("Link"+id);
	if (this.Parent!="") this.ParentNode=new Node(this.Parent);		
	
}
function SetExpandIcon(id,haschild,expand)
{
	var src="";
	var icon="";
	
	var obj=document.getElementById("Child"+id);
	if (!obj) return;
	if (expand)	{
		icon="M";
		obj.style.display="";}
	else{
		icon="P";
		obj.style.display="none";}		
	setElement("HasChild"+id,haschild);	//modified by csj 2020-02-22 ����ţ�1191924
	
	var eSrc=document.getElementById("Expand"+id);
	if (!eSrc) return;
	src=eSrc.src;
	lensrc=src.length;
	
	if (haschild){
		eSrc.style.cursor="hand";	}
	else{
		eSrc.style.cursor="";
		icon="L";}
	eSrc.src=src.substring(0,lensrc-6)+icon+src.substring(lensrc-5,lensrc);
}
