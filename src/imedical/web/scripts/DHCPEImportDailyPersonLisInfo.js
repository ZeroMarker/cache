/**
 * Ժ����Ա�������  DHCPEImportDailyPersonLisInfo.js
 * @Author   wangguoying sunxintao
 * @DateTime 2023-01-15
 */

var interval_num=9;  //������ˢ��Ƶ�� ÿinterval_num����¼ˢ��һ��
var aCity={11:"����",12:"���",13:"�ӱ�",14:"ɽ��",15:"���ɹ�",21:"����",22:"����",23:"������",31:"�Ϻ�",32:"����",33:"�㽭",34:"����",35:"����",36:"����",37:"ɽ��",41:"����",42:"����",43:"����",44:"�㶫",45:"����",46:"����",50:"����",51:"�Ĵ�",52:"����",53:"����",54:"����",61:"����",62:"����",63:"�ຣ",64:"����",65:"�½�",71:"̨��",81:"���",82:"����",91:"����"}
var editRows=new Array();  //�༭����������¼
/**��������ɾ������**/
Array.prototype.remove = function(val) { 
var index = this.indexOf(val); 
if (index > -1) { 
this.splice(index, 1); 
} 
};
$(init);
function init(){
	$(".datagrid-wrap.panel-body.panel-body-noheader.panel-header-gray").css("border-radius","0 0 4px 4px");
	$(".datagrid-wrap.panel-body.panel-body-noheader.panel-header-gray").css("border-top","0");
	if (("undefined"==typeof HISUIStyleCode)||(HISUIStyleCode==null)){
		
	}else{
		if(HISUIStyleCode=="lite") {
			$("#searchdiv").css(
		
			"border-bottom","dashed 1px #E2E2E2"
			
		
			)
		}else{
			$("#searchdiv").css(
		
			"border-bottom","dashed 1px #cccccc"
			
		
			)
		}
	}

	
}
var actionListObj = $HUI.datagrid("#actionList",{
		
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				var p = actionListObj.getPanel();
				p.find("#editIcon").linkbutton("enable",false);
				p.find("#delIcon").linkbutton("enable",false);
			}
		},	
		frozenColumns:[[
			{field:'TOperate',title:'����',width:'60',align:"center",
				formatter:function(value,row,index){
					return "<a href='#' onclick='edit_row(\""+index+"\",this)'>\
					<img style='padding-top:4px;' title='�޸ļ�¼' alt='�޸ļ�¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>\
					<a href='#' onclick='delete_row(\""+index+"\",\"\")'>\
					<img style='margin-left:8px; padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
					</a>";
				}
			},
			{field:'TStatus',title:'״̬',width:'60',sortable:'true',align:"center",
				formatter:function(value,row,index){
					var content="",cls=" statFont ";
					switch (row.TStatus){
						case 0:
							content="δ��֤";
							cls=cls+" statBg0 ";
							break;
						case 1:
							content="��֤ͨ��";
							cls=cls+" statBg0 ";
							break;
						case 2:
							content="����ɹ�";
							break;
						case -1:
							cls=cls+" statBg-1 ";
							content="��֤ʧ��";
							break;
						case -2:
							content="����ʧ��";
							cls=cls+" statBg-1 ";
							break;
					}
					return "<div class='"+cls+"' >"+content+"</div>";			
				}
			},
			//{field:'TTeam',width:'80',title:'������',editor:'text'},
			//{field:'TRegNo',width:'100',title:'�ǼǺ�',editor:'text'},
			//{field:'TName',width:'100',title:'����',editor:'text'},
			//{field:'TIDCard',width:'180',title:'���֤��',editor:'text'},
			{field:'TTipMsg',title:'����ʾ��Ϣ',hidden:'true'}
		]],
		columns:[[
			{field:'TPreIADM',align:"center",title:'ԤԼid',editor:'text'},
			{field:'TPAADM',title:'����id',editor:'text'},
			{field:'TADMDate',title:'�������',editor:'text'},
			{field:'TPatName',title:'����',editor:'text'},
			{field:'TPatSex',title:'�Ա�',editor:'text'},
			{field:'TPatAge',title:'��������',editor:'text'},
			{field:'TPatIDCard',title:'���֤��',editor:'text'},
			{field:'TPatTel',title:'�绰',editor:'text'},
			{field:'TLisStr',title:'����ҽ����',editor:'text'},
		]],
		data: {"total":0,"rows":[]},
		fit:true,
		rownumbers:true,
		onSortColumn:function(sort,order){
			sortTStatus(order);
		},
		rowTooltip: function(index,row){  //datagrid��չ����  ��������ʾ��Ϣ
			return row.TTipMsg;
		},
		rowStyler: function(index,row){
			var rowStyle="";
			switch (row.TStatus){
				case 0://δ��֤
					break;
				case 1://��֤ͨ��
					break;
				case 2://����ɹ�
					rowStyle='background-color:#65de65;'; 
					break;
				case -1://��֤δͨ��
					rowStyle='background-color:rgb(251, 136, 226);'; 
					break;
				case -2://����δͨ��
					break;
			}
			return rowStyle;
		},
		toolbar:[
		{
			iconCls:'icon-add',
			text:'������',
			handler:function(){
				add_row();
			}
		},{
			iconCls:'icon-cancel',
			text:'ɾ������֤ʧ�ܡ���¼',
			handler:function(){
				delete_row("",-1);
			}
		},{
			iconCls:'icon-cancel',
			text:'ɾ��������ɹ�����¼',
			handler:function(){
				delete_row("",2);
			}
		},{
			iconCls:'icon-reset',
			text:'�������',
			handler:function(){
				delete_row("",9);
			}
		},{
			iconCls:'icon-reload',
			text:'ˢ������',
			handler:function(){
				refresh_datagrid();
			}
		}]
	});

/**
 * [�в���]
 * @param    {[int]}    index [������]
 * @param    {[object]}    t     [��ť����]
 * @Author   wangguoying
 * @DateTime 2020-05-15
 */
function edit_row(index,t){
	if(editRows.indexOf(index)>-1){
		t.children[0].alt="�޸ļ�¼";
		t.children[0].title="�޸ļ�¼";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png";
		actionListObj.endEdit(index);
		editRows.remove(index);
		var data=actionListObj.getRows();
		data[index].TStatus=0;
		data[index].TTipMsg="";
		actionListObj.loadData(data);
		$("#DisplayMsg").html("�༭ 1 ��¼����ǰ�� "+data.length+" ��¼");
	}else{
		t.children[0].alt="�����¼";
		t.children[0].title="�����¼";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/save.png";
		actionListObj.beginEdit(index);
		editRows.push(index);
	}
}





/**
 * [״̬��ð������]
 * @param    {[string]}    order [asc:����  desc:����]
 * @Author   wangguoying
 * @DateTime 2020-05-11
 */
function sortTStatus(order){
	var data=actionListObj.getRows();
	for(var i=0;i<data.length;i++){
		for(var j=0;j<data.length-i-1;j++){
			var preObj=data[j];
			var sufObj=data[j+1];
			if((preObj.TStatus>sufObj.TStatus && order=="asc")||(preObj.TStatus<sufObj.TStatus && order=="desc")){
				data[j]=sufObj;
				data[j+1]=preObj;
			}
		}
	}
	actionListObj.loadData(data);
}


/**
 * [����Excel����]
 * @Author   wangguoying
 * @DateTime 2020-04-28
 */
function load_excel(){
	var fileList=$("#TemplateFile").filebox("files");
    if(fileList.length==0){
    	$.messager.alert("��ʾ","��ѡ��ģ�壡","info");
    	return false;
    }
	$('#Loading').css('display',"block"); 
	console.log("��ʼ��ȡ "+new Date());
    getExcelJsonArr(fileList[0],0,function(excelArr){
    	console.log("��ȡ��ɣ���"+excelArr.length+"��¼ "+new Date());
    	fillExcelData(excelArr);
    });  	
}

/**
 * [���Excel����]
 * @param    {JsonArray}    excelArr [Excel����]
 * @Author   wangguoying
 * @DateTime 2020-04-28
 */
function fillExcelData(excelArr){
	if(excelArr=="" || excelArr== "undefind" || excelArr.length==0){
		$.messager.alert("��ʾ","δ��ȡ��ģ�����ݣ����飡","info");
		$('#Loading').fadeOut('fast');
		return false;
	}	
	console.log("��ʼ�����棺"+new Date());
	setData(excelArr,0,actionListObj.getData());
}
/**
 * [׷��DataGrid ���ݰ�]
 * @param    {[JSONArray]}    excelArr [Excel����]
 * @param    {[int]}    i        [description]
 * @param    {[Object]}    OldData  [DataGrid ���ݰ�]
 * @Author   wangguoying
 * @DateTime 2020-04-30
 */
function setData(excelArr,i,OldData){
	var obj=excelArr[i];
	var jsonObj=new Object();
	jsonObj.TStatus=0;
	var PreIADM="";
	if(obj.ԤԼid) PreIADM = StringIsNull(obj.ԤԼid);
	jsonObj.TPreIADM=PreIADM;								//TName1
	var PAADM ="";
	if(obj.����id) PAADM = StringIsNull(obj.����id);
	jsonObj.TPAADM=PAADM;				//RegNo2
	
	var ADMDate ="";
	if(obj.�������) ADMDate = StringIsNull(obj.�������);
	jsonObj.TADMDate=ADMDate;

	var PatName="";
	if(obj.����) PatName = StringIsNull(obj.����);
	jsonObj.TPatName=PatName; 				//Name3
	
	var PatSex="";
	if(obj.�Ա�) PatSex = StringIsNull(obj.�Ա�);
	jsonObj.TPatSex=PatSex; 
	
	
	var PatAge="";
	if(obj.��������) PatAge = StringIsNull(obj.��������);
	jsonObj.TPatAge=PatAge; 				
    
    
    var PatIDCard="";
	if(obj.���֤��) PatIDCard = StringIsNull(obj.���֤��);
	jsonObj.TPatIDCard=PatIDCard;  
	
	
	 var PatTel="";
	if(obj.�绰) PatTel = StringIsNull(obj.�绰);
	jsonObj.TPatTel=PatTel;  
    
     var LisStr="";
	if(obj.����ҽ����) LisStr = StringIsNull(obj.����ҽ����);
	jsonObj.TLisStr=LisStr;  

	
	OldData.rows.push(jsonObj);
	
	if(i==(excelArr.length-1)){
		actionListObj.loadData(OldData);
		afterFill(excelArr.length);
	}else{
		if(i%interval_num==0){
			$("#LoadMsg").html("������ݣ�<font color='red'> "+(i+1)+"</font>/"+excelArr.length);
		}
		setTimeout(function(){setData(excelArr,i+1,OldData);},0);
	}
}


/**
 * [�����������¼�]
 * @param    {[int]}    length [��ȡ�ܼ�¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterFill(length){
	console.log("�����ɣ�"+new Date());
	$("#DisplayMsg").html("���μ���<font color='red'> "+length+"</font> ��¼����ǰ��<font color='red'> "+actionListObj.getRows().length+"</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}



function operate_data(type){
	var job = session['LOGON.USERID'];
	var jobObj = document.getElementById("Job");
	if (jobObj) job = jobObj.value;
	KillImportGlobal(job);
	var rows=actionListObj.getRows();
	if(rows.length==0){
		$.messager.alert("��ʾ","δ�����κ�����","info");
		return false;
	}
	if(editRows.length>0){
		$.messager.alert("��ʾ","����δ��������ݣ��뱣������","info");
		return false;
	}
	$('#Loading').css('display',"block"); 
	if(type=="Check"){
		valid_rowData(job,rows,0,0);
	}
	if(type=="Import"){
		var needNum=getNumByStatus(1);
		import_rowData(job, rows,0,0,0,needNum);
	}
}
/**
 * [��������ָ֤������]
 * @param    {[int]}    job [���̺�]
 * @param    {[array]}    rowData [������ݰ�]
 * @param    {[int]}    index   [��������]
 * @param    {[int]}    failNum   [��֤ʧ�ܼ�¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function valid_rowData(job,rowData,index,failNum){
	var data=rowData[index];
	if(data.TStatus!=2){  //����ɹ��Ĳ�����֤
		var instring=valid_obj(job,data,index);
		if(instring==""){
			failNum++;
			data.TStatus=-1;
		}else{
			data.TStatus=1;
		}
	}
	
	if(index==(rowData.length-1)){
		KillImportGlobal(job);
		actionListObj.loadData(rowData);
		afterValid(failNum);		
	}else{
		if(index%interval_num==0){
			$("#LoadMsg").html("��֤���ݣ�<font color='red'> "+(index+1)+"</font>/"+rowData.length);
		}
		setTimeout(function(){valid_rowData(job,rowData,index+1,failNum);},0);
	}

}

/**
 * [��֤������]
 * @param    {[int]}    job [���̺�]
 * @param    {[object]}    obj   [������]
 * @param    {[int]}    index [������]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function valid_obj(job,obj,index){
	var IInString = "";
	var PreIADM="";
	if(obj.TPreIADM) PreIADM = StringIsNull(obj.TPreIADM);
	IInString = PreIADM; 								//TName1
	var PAADM ="";
	if(obj.TPAADM) PAADM = StringIsNull(obj.TPAADM);
	IInString = IInString + "^" + PAADM; 				//RegNo2
	
	var ADMDate ="";
	if(obj.TADMDate) ADMDate = StringIsNull(obj.TADMDate);
	IInString = IInString + "^" + ADMDate; 

	var PatName="";
	if(obj.TPatName) PatName = StringIsNull(obj.TPatName);
	IInString = IInString + "^" + PatName; 			
	if(PatName==""){
		obj.TTipMsg="����Ϊ��";
		return "";
	}
	
	var PatSex="";
	if(obj.TPatSex) PatSex = StringIsNull(obj.TPatSex);
	IInString = IInString + "^" + PatSex; 		
	
	var PatAge="";
	if(obj.TPatAge) PatAge = StringIsNull(obj.TPatAge);
	IInString = IInString + "^" + PatAge; 	
	
	
	var PatIDCard="";
	if(obj.TPatIDCard) PatIDCard = StringIsNull(obj.TPatIDCard);
	IInString = IInString + "^" + PatIDCard; 
	
	var PatTel="";
	if(obj.TPatTel) PatTel = StringIsNull(obj.TPatTel);
	IInString = IInString + "^" + PatTel; 
	
	var LisStr="";
	if(obj.TLisStr) LisStr = StringIsNull(obj.TLisStr);
	IInString = IInString + "^" + LisStr; 
	//alert(LisStr)
	if(LisStr==""){
		obj.TTipMsg="���鴮Ϊ��";
		return "";
	}
	
	IInString=IInString+"^"+(index+1);    //�кŷŵ����
	//alert($("#GDesc").val())
	
	
	var ReturnValue = tkMakeServerCall("web.DHCPE.SecretPE", "GetSecretInfo", IInString, "Check", job);
	if (ReturnValue != 0) {
		var RetArr = ReturnValue.split("&");
		if(RetArr.length>1){
			obj.TTipMsg=RetArr[0]+":"+RetArr[1];
		}else{
			obj.TTipMsg=RetArr[0];
		}
		return "";
	}
   
	return IInString;
}

/**
 * [��֤����¼�]
 * @param    {[int]}    failNum   [��֤ʧ�ܼ�¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterValid(failNum){
	sortTStatus("asc");  //��֤��ɺ����򣬽��������Ϣ��ʾ������
	$("#DisplayMsg").html("����֤ "+actionListObj.getRows().length+" ��¼��ʧ��<font color='red'> "+failNum+"</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}


/**
 * [��ȡָ��״̬�ļ�¼����]
 * @param    {[int]}    Status [0:δ��֤  1:��֤�ɹ�  2:����ɹ�  -1:��֤ʧ��  -2:����ʧ��]
 * @return   {[int]}           [��¼����]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function getNumByStatus(Status){
	var data=actionListObj.getData();
	var tatal=data.total;
	if(Status=="")  return total;
	var num=0;
	for(var row in data.rows){
		if(data.rows[row].TStatus==Status) num++;
	}
	return num;
}

/**
 * [����������]
 * @param    {[int]}    job        [���̺�]
 * @param    {[object]}    rowData    [������ݰ�]
 * @param    {[index]}    index      [������]
 * @param    {[int]}    failNum    [ʧ�ܼ�¼��]
 * @param    {[int]}    successNum [�ɹ���¼��]
 * @param    {[int]}    needNum    [Ӧ��������]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function import_rowData(job, rowData,index,failNum,successNum,needNum){
	var importRet=tkMakeServerCall("web.DHCPE.SecretPE","Main",job);
	$('#Loading').fadeOut('fast');
	alert("�������");
	return false;	
	
	var data=rowData[index];
	if(data.TStatus==1){  //��֤�ɹ��Ĳ���ִ�е���
		var instring=valid_obj(job,data,index);
		if(instring==""){
			failNum++;
			data.TStatus=-1;
		}else{
			var importRet=tkMakeServerCall("web.DHCPE.SecretPE","Main",job);
			//alert(importRet)
			var ReturnStr=importRet.split("^");
			var Flag=ReturnStr[0];
			if (Flag!=0){
				//alert(Flag)
				failNum++;
				data.TStatus=-2;
				data.TTipMsg=Flag;
			}else{
				//alert(ReturnStr[3])
				if(ReturnStr[3]==1){
					successNum++;
					data.TStatus=2;
				}else{
					failNum++;
					data.TStatus=-2;
					data.TTipMsg=tkMakeServerCall("web.DHCPE.SecretPE","GetImportErr",job,index+1);
				}
			}
		}
	}
	if(needNum==(failNum+successNum)){
		actionListObj.loadData(rowData);
		afterImport(failNum,needNum);
	}else{
		if((failNum+successNum-1)%interval_num==0){
			$("#LoadMsg").html("�������ݣ�<font color='red'> "+(failNum+successNum)+"</font>/"+needNum);
		}
		setTimeout(function(){import_rowData(job, rowData,index+1,failNum,successNum,needNum);},1000);
	}

}

/**
 * [��������¼�]
 * @param    {[int]}    failNum   [����ʧ�ܼ�¼��]
 * @param    {[int]}    successNum   [����ɹ���¼��]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterImport(failNum,successNum){
	sortTStatus("asc");  //������ɺ����򣬽��������Ϣ��ʾ������
	$("#DisplayMsg").html("������ "+successNum+" ��¼��ʧ��<font color='red'> "+failNum+"</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}


function refresh_datagrid(){
	actionListObj.reload();
}

function delete_row(index,status){
	if(index!="" && index>-1){
		var tr =actionListObj.getRowDom(index);
        tr.tooltip("destroy").children("td[field]").each(function () {
            $(this).tooltip("destroy");
        });
		actionListObj.deleteRow(index);
		actionListObj.loadData(actionListObj.getRows());
		$("#DisplayMsg").html("ɾ�� 1 ��¼����ǰ�� "+actionListObj.getRows().length+" ��¼");
		$.messager.alert("��ʾ","��ɾ��","success");
		return;
	}else{
		var statusDesc="";
		switch(status){
			case 0:
				statusDesc="δ��֤";
				break;
			case 1:
				statusDesc="��֤�ɹ�";
				break;
			case 2:
				statusDesc="����ɹ�";
				break;
			case -1:
				statusDesc="��֤ʧ��";
				break;
			case -2:
				statusDesc="����ʧ��";
				break;
		}
		if(statusDesc==""){//ȫ������
			$.messager.confirm("��ʾ","���ȫ����¼��",function(r){
				if(r){
					actionListObj.loadData({"total":0,"rows":[]});
					$("#DisplayMsg").html("������");
				}
			});
			
		}else{
			$.messager.confirm("��ʾ","ɾ��״̬Ϊ��"+statusDesc+"����ȫ����¼��",function(r){
				if(r){
					var data=actionListObj.getRows();
					var oldLen=data.length;
					var newData=[];
					for(var i=0;i<oldLen;i++){
						if(data[i].TStatus!=status){
							newData.push(data[i]);
						}
					}
					var newLen=newData.length;
					actionListObj.loadData(newData);
					$("#DisplayMsg").html("ɾ�� "+(oldLen-newLen)+" ��¼����ǰ�� "+newLen+" ��¼");
				}
			});
		}
		
	}
}
function add_row(){
	actionListObj.appendRow({TStatus:0});
	$("#DisplayMsg").html("���� 1 ��¼����ǰ�� "+actionListObj.getRows().length+" ��¼");
}


function KillImportGlobal(job)
{
	var ReturnValue=tkMakeServerCall("web.DHCPE.ImportGInfo","KillImportGlobal",job);
	
	return ReturnValue;
}



//ȥ���ַ������˵Ŀո�
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//ȥ���ַ����Ŀո�
function jsTrim(str) 
{
	var reg=/\s/;
	if(!reg.test(str)){return str;}
	return str.replace(/\s+/g,"");
}

function StringIsNull(String)
{
	if (String==null) return ""
	//return String
	return jsTrim(String)
}

//ȥ���ַ������˵Ŀո�
function ReplaceStr(s,Split,LinkStr)
{
	if (""==s) { return ""; }
	var SArr=s.split(Split)
	s=SArr.join(LinkStr)
	return s
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function GetBirthByIDCard(num)
{
	if (num=="") return "";
	//alert(toString(num))
	var ShortNum=num.substr(0,num.length-1)
	if (isNaN(ShortNum))
	{
		//alert("����Ĳ�������?");
		return "";
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {//alert("���֤�����������λ������?");
	//websys_setfocus("IDCard");
	return "";}
	var a = (ShortNum+"1").match(re);
	if (a != null)
	{
		if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
			var SexFlag=num.substr(16,1);
		}
		
		
		if (!B)
		{
			//alert("��������֤�� "+ a[0] +" ��������ڲ���?");
			
			//websys_setfocus("IDCard"); //DGV2DGV2
			if (a[3].length==2) a[3]="19"+a[3];
			Str=a[3]+"-"+a[4]+"-"+a[5];
			return Str;
		}
		if (a[3].length==2) a[3]="19"+a[3];
		var Str=a[3]+"-"+a[4]+"-"+a[5];
		
		
		var SexNV=""
		if (SexFlag%2==1)
		{
			SexNV="��";
		}
		else
		{
			SexNV="Ů";
		}
		
		
		return Str+"^"+SexNV;
		
	}
	return "";
}
function IsDate(str) 
{ 
   var re = /^\d{4}-\d{1,2}-\d{1,2}$/; 
   if(re.test(str)) 
   { 
       // ��ʼ���ڵ��߼��ж�??�Ƿ�Ϊ�Ϸ������� 
       var array = str.split('-'); 
       var date = new Date(array[0], parseInt(array[1], 10) - 1, array[2]); 
       if(!((date.getFullYear() == parseInt(array[0], 10)) 
           && ((date.getMonth() + 1) == parseInt(array[1], 10)) 
           && (date.getDate() == parseInt(array[2], 10)))) 
       { 
           // ������Ч������ 
           return false; 
       } 
       return true; 
   } 

   // ���ڸ�ʽ���� 
   return false; 
} 
function isCardID(sId){
 var iSum=0 ;
 var info="" ;
 if(sId=="") return true;
 if(!/^\d{17}(\d|x)$/i.test(sId)) return "����������֤���Ȼ��ʽ����";
 sId=sId.replace(/x$/i,"a");
 if(aCity[parseInt(sId.substr(0,2))]==null) return "������֤�����Ƿ�";
 sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));
 var d=new Date(sBirthday.replace(/-/g,"/")) ;
 if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))return "���֤�ϵĳ������ڷǷ�";
 for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;
 if(iSum%11!=1) return "����������֤�ŷǷ�";
 //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"��":"Ů");//�˴λ������жϳ���������֤�ŵ����Ա�
 return true;
} 