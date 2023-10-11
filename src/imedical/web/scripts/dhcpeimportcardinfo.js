// dhcpeimportcardinfo.js

var interval_num=9;  //������ˢ��Ƶ�� ÿinterval_num����¼ˢ��һ��
var editRows=new Array();  //�༭����������¼
/**��������ɾ������**/
Array.prototype.remove = function(val) { 
	var index = this.indexOf(val); 
	if (index > -1) { 
		this.splice(index, 1); 
	}
};

var actionListObj = $HUI.datagrid("#actionList",{
	onSelect:function(rowIndex,rowData){
		if (rowIndex>-1){
			var p = actionListObj.getPanel();
			p.find("#editIcon").linkbutton("enable",false);
			p.find("#delIcon").linkbutton("enable",false);
		}
	},	
	// frozenColumns:[[]],
	columns:[[
		{field:'TOperate',title:'����',width:60, align:"center",
			formatter:function(value,row,index){
				return "<a href='#' onclick='edit_row(\""+index+"\",this)'>\
				<img style='padding-top:4px;' title='�޸ļ�¼' alt='�޸ļ�¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png' border=0/>\
				</a>\
				<a href='#' onclick='delete_row(\""+index+"\",\"\")'>\
				<img style='margin-left:8px; padding-top:4px;' title='ɾ����¼' alt='ɾ����¼' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
		},
		{field:'TStatus',title:'״̬',width:60,sortable:'true',align:"center",
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
		{field:'TCardNo',width:120,title:'��ֵ����',editor:'text',sortable:'true'},
		{field:'TName',width:100,title:'����',editor:'text'},
		{field:'TAmt',width:70,title:'��ֵ���',editor:'text'},
		{field:'TRemark',width:180,title:'��ע',editor:'text'},
		{field:'TSex',width:40,align:"center",title:'�Ա�',editor:'text'},
		{field:'TTel',width:100,title:'��ϵ��ʽ',editor:'text'},
		{field:'TIDCard',width:100,title:'֤����',editor:'text'},
		{field:'TEndDate',width:100,title:'��ֹ����',editor:'text'},
		{field:'TTipMsg',title:'����ʾ��Ϣ',hidden:'true'}
	]],
	data: {"total":0,"rows":[]},
	fit:true,
	rownumbers:true,
	fitColumns:true,
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
	}
	/*,
	toolbar:[
	{
		iconCls:'icon-close',
		text:'ɾ������֤ʧ�ܡ���¼',
		handler:function(){
			delete_row("",-1);
		}
	},{
		iconCls:'icon-close',
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
	},{
		iconCls:'icon-export',
		text:'������������',
		handler:function(){
			export_errData();
		}
	},{
		iconCls:'icon-key-switch',
		text:'����֤�ɹ�',
		handler:function(){
			update_status(1);
		}
	}]
	*/
});

/**
 * [״̬��ð������]
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
 */
function setData(excelArr,i,OldData){
	var obj=excelArr[i];
	var jsonObj=new Object();
	jsonObj.TStatus=0;
	var CardNo="";
	if(obj.��ֵ����) CardNo = StringIsNull(obj.��ֵ����);
	jsonObj.TCardNo=CardNo;
	
	var Name="";
	if(obj.����) Name = StringIsNull(obj.����);
	jsonObj.TName=Name;
	
	var Sex="";
	if(obj.�Ա�) Sex = StringIsNull(obj.�Ա�);
	jsonObj.TSex=Sex;
	
	var Amt="";
	if(obj.��ֵ���) Amt = StringIsNull(obj.��ֵ���);
	jsonObj.TAmt=Amt;
	
	var Remark="";
	if(obj.��ע) Remark = StringIsNull(obj.��ע);
	Remark = ReplaceStr(Remark, String.fromCharCode(10), "");
	Remark = ReplaceStr(Remark, String.fromCharCode(13), "")
	jsonObj.TRemark=Remark;

	var Tel="";
	if(obj.��ϵ��ʽ) Tel = StringIsNull(obj.��ϵ��ʽ);
	jsonObj.TTel= Tel;
	
	var IDCard="";
	if(obj.֤����) IDCard = StringIsNull(obj.֤����);
	jsonObj.TIDCard= IDCard;
	
	var EndDate="";
	if(obj.��ֹ����) EndDate = StringIsNull(obj.��ֹ����);
	jsonObj.TEndDate= EndDate;
	
	OldData.rows.push(jsonObj);
	
	if(i==(excelArr.length-1)){
		actionListObj.loadData(OldData);
		afterFill(excelArr.length);
	}else{
		if(i%interval_num==0){
			$("#LoadMsg").html("������ݣ�<font color='red'> "+(i+1)+"</font>/"+excelArr.length);
			// onsole.log($("#LoadMsg").html());
		}		
		setTimeout(function(){setData(excelArr,i+1,OldData);},0);
	}
}

/**
 * [�����������¼�]
 */
function afterFill(length){
	console.log("�����ɣ�"+new Date());
	$("#TemplateFile").filebox("clear");
	$("#DisplayMsg").html("���μ���<font color='red'> "+length+"</font> ��¼����ǰ��<font color='red'> "+actionListObj.getRows().length+"</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
}

/**
 * [�в���]
 */
function edit_row(index,t){
	if(editRows.indexOf(index)>-1){
		t.children[0].alt="�޸ļ�¼";
		t.children[0].title="�޸ļ�¼";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png";
		actionListObj.endEdit(index);
		editRows.remove(index);
		var data=actionListObj.getRows();
		data[index].TStatus=0;
		data[index].TTipMsg="";
		actionListObj.loadData(data);
		$("#DisplayMsg").html("�༭ 1 ��¼����ǰ�� "+data.length+" ��¼");
	}else{
		if(editRows.length>0){
			$.messager.alert("��ʾ","����δ��������ݣ��뱣������","info");
			return false;
		}
		t.children[0].alt="�����¼";
		t.children[0].title="�����¼";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/save.png";
		actionListObj.beginEdit(index);
		var tr =actionListObj.getRowDom(index);
        tr.tooltip("destroy").children("td[field]").each(function () {
            $(this).tooltip("destroy");
        });
		editRows.push(index);
	}
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
					editRows = new Array();
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

/**
 * [������״̬]
 */
function update_status(status){
	var selectObj = $("#actionList").datagrid("getSelected");
	var selectIndex = $("#actionList").datagrid("getRowIndex",selectObj);
	if(selectObj == null){
		$.messager.alert("��ʾ","��ѡ�����޸ĵ��м�¼","info");
		return false;
	}
	selectObj.TStatus = status;
	$('#actionList').datagrid('updateRow',{
		index: selectIndex,
		row: selectObj
	});
}

function KillImportGlobal(job) {
	var ReturnValue=tkMakeServerCall("web.DHCPE.ImportCardInfo","KillImportGlobal",job);
	return ReturnValue;
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
 */
function valid_obj(job,obj,index){
	var IInString = "";
	obj.TTipMsg = "";
	var HospID=session['LOGON.HOSPID'];
	var LocID=session['LOGON.CTLOCID'];
	
	var CardNo = "";
	if(obj.TCardNo) CardNo = StringIsNull(obj.TCardNo);		// ��ֵ����
	IInString = CardNo;
	if (CardNo == "") {
		obj.TTipMsg="��ֵ����Ϊ��";
		return "";
	}
	
	var Name = "";
	if(obj.TName) Name = StringIsNull(obj.TName);			// ����
	if (Name == "") {
		obj.TTipMsg="����Ϊ��";
		return "";
	}
	IInString = IInString + "^" + Name;
	
	var Sex = "";
	if(obj.TSex) Sex = StringIsNull(obj.TSex);			// ����
	IInString = IInString + "^" + Sex;
	
	var Amt = "";
	if(obj.TAmt) Amt = StringIsNull(obj.TAmt);				// ��ֵ���
	if(Amt == ""){
		obj.TTipMsg="��ֵ���Ϊ��";
		return "";
	}
	IInString = IInString + "^" + Amt;
	
	var Remark = "";
	if(obj.TRemark) Remark = StringIsNull(obj.TRemark);
	Remark = ReplaceStr(Remark, String.fromCharCode(10), "");
	Remark = ReplaceStr(Remark, String.fromCharCode(13), "");
	IInString = IInString + "^" + Remark;					// ��ע
	
	var Tel = "";
	if(obj.TTel) Tel = StringIsNull(obj.TTel);
	var IsvalidTel="";
	if(Tel!=""){
	var IsvalidTel = isMoveTel(Tel);
		if (IsvalidTel != true) {
			obj.TTipMsg = "��ϵ�绰�Ƿ�";
			return "";
		}
	}
	IInString = IInString + "^" + Tel;						// ��ϵ��ʽ
	
	var IDCard = "";
	if(obj.TIDCard) IDCard = StringIsNull(obj.TIDCard);
	IInString = IInString + "^" + IDCard;						// ֤����
	
	var EndDate = "";
	if(obj.TEndDate) EndDate = StringIsNull(obj.TEndDate);
	IInString = IInString + "^" + EndDate;						// ��ֹ����
	
	IInString=IInString+"^"+(index+1);						// �кŷŵ����
	
	var itAmt = "";
	itAmt = $("#ImpTotalAmt").numberbox("getValue");
	
	var ReturnValue = tkMakeServerCall("web.DHCPE.ImportCardInfo", "GetCardInfo", $("#ImpSourceCardID").val(), IInString, "Check", job, itAmt,HospID,LocID);
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
 */
function import_rowData(job, rowData,index,failNum,successNum,needNum){
	var data=rowData[index];
	if(data.TStatus==1){  //��֤�ɹ��Ĳ���ִ�е���
		var instring=valid_obj(job, data, index);
		if(instring==""){
			failNum++;
			data.TStatus=-1;
		}else{
			console.log("���룬��"+index+"");
			var importRet = tkMakeServerCall("web.DHCPE.ImportCardInfo", "Main", $("#ImpSourceCardID").val(), job);
			var ReturnStr = importRet.split("^");
			var TNum = ReturnStr[0];
			var SNum = ReturnStr[1];
			var FNum = ReturnStr[2];
			if (FNum > 0){
				failNum++;
				data.TStatus=-2;
				data.TTipMsg=tkMakeServerCall("web.DHCPE.ImportCardInfo","GetImportErr", $("#ImpSourceCardID").val(), job, index+1);
			}else if (TNum != SNum){
				
				failNum++;
				data.TStatus=-2;
				data.TTipMsg=tkMakeServerCall("web.DHCPE.ImportCardInfo","GetImportErr", $("#ImpSourceCardID").val(), job, index+1);
			} else {
				successNum++;
				data.TStatus=2;
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
		setTimeout(function(){import_rowData(job, rowData,index+1,failNum,successNum,needNum);},0);
	}

}

/**
 * [��������¼�]
 */
function afterImport(failNum,successNum){
	sortTStatus("asc");  //������ɺ����򣬽��������Ϣ��ʾ������
	$("#DisplayMsg").html("������ "+successNum+" ��¼��ʧ��<font color='red'> "+failNum+"</font> ��¼");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("�����С���");
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
	if(s!="" && s!=null && typeof(s)!="undefined"){
		s = s + "";
		var SArr=s.split(Split)
		s=SArr.join(LinkStr)
		return s
		var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
		return (m == null) ? "" : m[1];
	}else{
		return "";
	}
	
}

/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
    
    var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
    var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
    var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
    if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
        return false; 
    }else{ 
        return true; 
    } 

}
