// dhcpeimportcardinfo.js

var interval_num=9;  //进度条刷新频率 每interval_num条记录刷新一次
var editRows=new Array();  //编辑的行索引记录
/**定义数组删除函数**/
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
		{field:'TOperate',title:'操作',width:60, align:"center",
			formatter:function(value,row,index){
				return "<a href='#' onclick='edit_row(\""+index+"\",this)'>\
				<img style='padding-top:4px;' title='修改记录' alt='修改记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png' border=0/>\
				</a>\
				<a href='#' onclick='delete_row(\""+index+"\",\"\")'>\
				<img style='margin-left:8px; padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
				</a>";
			}
		},
		{field:'TStatus',title:'状态',width:60,sortable:'true',align:"center",
			formatter:function(value,row,index){
				var content="",cls=" statFont ";
				switch (row.TStatus){
					case 0:
						content="未验证";
						cls=cls+" statBg0 ";
						break;
					case 1:
						content="验证通过";
						cls=cls+" statBg0 ";
						break;
					case 2:
						content="导入成功";
						break;
					case -1:
						cls=cls+" statBg-1 ";
						content="验证失败";
						break;
					case -2:
						content="导入失败";
						cls=cls+" statBg-1 ";
						break;
				}
				return "<div class='"+cls+"' >"+content+"</div>";			
			}
		},
		{field:'TCardNo',width:120,title:'充值卡号',editor:'text',sortable:'true'},
		{field:'TName',width:100,title:'姓名',editor:'text'},
		{field:'TAmt',width:70,title:'充值金额',editor:'text'},
		{field:'TRemark',width:180,title:'备注',editor:'text'},
		{field:'TSex',width:40,align:"center",title:'性别',editor:'text'},
		{field:'TTel',width:100,title:'联系方式',editor:'text'},
		{field:'TIDCard',width:100,title:'证件号',editor:'text'},
		{field:'TEndDate',width:100,title:'截止日期',editor:'text'},
		{field:'TTipMsg',title:'行提示信息',hidden:'true'}
	]],
	data: {"total":0,"rows":[]},
	fit:true,
	rownumbers:true,
	fitColumns:true,
	onSortColumn:function(sort,order){
		sortTStatus(order);
	},
	rowTooltip: function(index,row){  //datagrid拓展属性  返回行提示信息
		return row.TTipMsg;
	},
	rowStyler: function(index,row){
		var rowStyle="";
		switch (row.TStatus){
			case 0://未验证
				break;
			case 1://验证通过
				break;
			case 2://导入成功
				rowStyle='background-color:#65de65;'; 
				break;
			case -1://验证未通过
				rowStyle='background-color:rgb(251, 136, 226);'; 
				break;
			case -2://导入未通过
				break;
		}
		return rowStyle;
	}
	/*,
	toolbar:[
	{
		iconCls:'icon-close',
		text:'删除【验证失败】记录',
		handler:function(){
			delete_row("",-1);
		}
	},{
		iconCls:'icon-close',
		text:'删除【导入成功】记录',
		handler:function(){
			delete_row("",2);
		}
	},{
		iconCls:'icon-reset',
		text:'清空数据',
		handler:function(){
			delete_row("",9);
		}
	},{
		iconCls:'icon-reload',
		text:'刷新数据',
		handler:function(){
			refresh_datagrid();
		}
	},{
		iconCls:'icon-export',
		text:'导出错误数据',
		handler:function(){
			export_errData();
		}
	},{
		iconCls:'icon-key-switch',
		text:'置验证成功',
		handler:function(){
			update_status(1);
		}
	}]
	*/
});

/**
 * [状态列冒泡排序]
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
 * [加载Excel数据]
 */
function load_excel(){
	var fileList=$("#TemplateFile").filebox("files");
    if(fileList.length==0){
    	$.messager.alert("提示","请选择模板！","info");
    	return false;
    }
	$('#Loading').css('display',"block"); 
	console.log("开始读取 "+new Date());
    getExcelJsonArr(fileList[0],0,function(excelArr){
    	console.log("读取完成，共"+excelArr.length+"记录 "+new Date());
    	fillExcelData(excelArr);
    });  	
}

/**
 * [填充Excel数据]
 */
function fillExcelData(excelArr){
	if(excelArr=="" || excelArr== "undefind" || excelArr.length==0){
		$.messager.alert("提示","未读取到模板数据，请检查！","info");
		$('#Loading').fadeOut('fast');
		return false;
	}	
	console.log("开始填充界面："+new Date());
	setData(excelArr,0,actionListObj.getData());
}

/**
 * [追加DataGrid 数据包]
 */
function setData(excelArr,i,OldData){
	var obj=excelArr[i];
	var jsonObj=new Object();
	jsonObj.TStatus=0;
	var CardNo="";
	if(obj.充值卡号) CardNo = StringIsNull(obj.充值卡号);
	jsonObj.TCardNo=CardNo;
	
	var Name="";
	if(obj.姓名) Name = StringIsNull(obj.姓名);
	jsonObj.TName=Name;
	
	var Sex="";
	if(obj.性别) Sex = StringIsNull(obj.性别);
	jsonObj.TSex=Sex;
	
	var Amt="";
	if(obj.充值金额) Amt = StringIsNull(obj.充值金额);
	jsonObj.TAmt=Amt;
	
	var Remark="";
	if(obj.备注) Remark = StringIsNull(obj.备注);
	Remark = ReplaceStr(Remark, String.fromCharCode(10), "");
	Remark = ReplaceStr(Remark, String.fromCharCode(13), "")
	jsonObj.TRemark=Remark;

	var Tel="";
	if(obj.联系方式) Tel = StringIsNull(obj.联系方式);
	jsonObj.TTel= Tel;
	
	var IDCard="";
	if(obj.证件号) IDCard = StringIsNull(obj.证件号);
	jsonObj.TIDCard= IDCard;
	
	var EndDate="";
	if(obj.截止日期) EndDate = StringIsNull(obj.截止日期);
	jsonObj.TEndDate= EndDate;
	
	OldData.rows.push(jsonObj);
	
	if(i==(excelArr.length-1)){
		actionListObj.loadData(OldData);
		afterFill(excelArr.length);
	}else{
		if(i%interval_num==0){
			$("#LoadMsg").html("填充数据：<font color='red'> "+(i+1)+"</font>/"+excelArr.length);
			// onsole.log($("#LoadMsg").html());
		}		
		setTimeout(function(){setData(excelArr,i+1,OldData);},0);
	}
}

/**
 * [填充数据完成事件]
 */
function afterFill(length){
	console.log("填充完成："+new Date());
	$("#TemplateFile").filebox("clear");
	$("#DisplayMsg").html("本次加载<font color='red'> "+length+"</font> 记录，当前共<font color='red'> "+actionListObj.getRows().length+"</font> 记录");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("处理中……");
}

/**
 * [行操作]
 */
function edit_row(index,t){
	if(editRows.indexOf(index)>-1){
		t.children[0].alt="修改记录";
		t.children[0].title="修改记录";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png";
		actionListObj.endEdit(index);
		editRows.remove(index);
		var data=actionListObj.getRows();
		data[index].TStatus=0;
		data[index].TTipMsg="";
		actionListObj.loadData(data);
		$("#DisplayMsg").html("编辑 1 记录，当前共 "+data.length+" 记录");
	}else{
		if(editRows.length>0){
			$.messager.alert("提示","存在未保存的数据，请保存后操作","info");
			return false;
		}
		t.children[0].alt="保存记录";
		t.children[0].title="保存记录";
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
		$("#DisplayMsg").html("删除 1 记录，当前共 "+actionListObj.getRows().length+" 记录");
		$.messager.alert("提示","已删除","success");
		return;
	}else{
		var statusDesc="";
		switch(status){
			case 0:
				statusDesc="未验证";
				break;
			case 1:
				statusDesc="验证成功";
				break;
			case 2:
				statusDesc="导入成功";
				break;
			case -1:
				statusDesc="验证失败";
				break;
			case -2:
				statusDesc="导入失败";
				break;
		}
		if(statusDesc==""){//全清数据
			$.messager.confirm("提示","清除全部记录？",function(r){
				if(r){
					editRows = new Array();
					actionListObj.loadData({"total":0,"rows":[]});
					$("#DisplayMsg").html("无数据");
				}
			});
			
		}else{
			$.messager.confirm("提示","删除状态为【"+statusDesc+"】的全部记录？",function(r){
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
					$("#DisplayMsg").html("删除 "+(oldLen-newLen)+" 记录，当前共 "+newLen+" 记录");
				}
			});
		}
		
	}
}

/**
 * [更新行状态]
 */
function update_status(status){
	var selectObj = $("#actionList").datagrid("getSelected");
	var selectIndex = $("#actionList").datagrid("getRowIndex",selectObj);
	if(selectObj == null){
		$.messager.alert("提示","请选择需修改的行记录","info");
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
		$.messager.alert("提示","未加载任何数据","info");
		return false;
	}
	if(editRows.length>0){
		$.messager.alert("提示","存在未保存的数据，请保存后操作","info");
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
 * [按索引验证指定数据]
 */
function valid_rowData(job,rowData,index,failNum){
	var data=rowData[index];
	if(data.TStatus!=2){  //导入成功的不再验证
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
			$("#LoadMsg").html("验证数据：<font color='red'> "+(index+1)+"</font>/"+rowData.length);
		}
		setTimeout(function(){valid_rowData(job,rowData,index+1,failNum);},0);
	}

}

/**
 * [验证数据行]
 * @param    {[int]}    job [进程号]
 */
function valid_obj(job,obj,index){
	var IInString = "";
	obj.TTipMsg = "";
	var HospID=session['LOGON.HOSPID'];
	var LocID=session['LOGON.CTLOCID'];
	
	var CardNo = "";
	if(obj.TCardNo) CardNo = StringIsNull(obj.TCardNo);		// 充值卡号
	IInString = CardNo;
	if (CardNo == "") {
		obj.TTipMsg="充值卡号为空";
		return "";
	}
	
	var Name = "";
	if(obj.TName) Name = StringIsNull(obj.TName);			// 姓名
	if (Name == "") {
		obj.TTipMsg="姓名为空";
		return "";
	}
	IInString = IInString + "^" + Name;
	
	var Sex = "";
	if(obj.TSex) Sex = StringIsNull(obj.TSex);			// 姓名
	IInString = IInString + "^" + Sex;
	
	var Amt = "";
	if(obj.TAmt) Amt = StringIsNull(obj.TAmt);				// 充值金额
	if(Amt == ""){
		obj.TTipMsg="充值金额为空";
		return "";
	}
	IInString = IInString + "^" + Amt;
	
	var Remark = "";
	if(obj.TRemark) Remark = StringIsNull(obj.TRemark);
	Remark = ReplaceStr(Remark, String.fromCharCode(10), "");
	Remark = ReplaceStr(Remark, String.fromCharCode(13), "");
	IInString = IInString + "^" + Remark;					// 备注
	
	var Tel = "";
	if(obj.TTel) Tel = StringIsNull(obj.TTel);
	var IsvalidTel="";
	if(Tel!=""){
	var IsvalidTel = isMoveTel(Tel);
		if (IsvalidTel != true) {
			obj.TTipMsg = "联系电话非法";
			return "";
		}
	}
	IInString = IInString + "^" + Tel;						// 联系方式
	
	var IDCard = "";
	if(obj.TIDCard) IDCard = StringIsNull(obj.TIDCard);
	IInString = IInString + "^" + IDCard;						// 证件号
	
	var EndDate = "";
	if(obj.TEndDate) EndDate = StringIsNull(obj.TEndDate);
	IInString = IInString + "^" + EndDate;						// 截止日期
	
	IInString=IInString+"^"+(index+1);						// 行号放到最后
	
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
 * [验证完成事件]
 */
function afterValid(failNum){
	sortTStatus("asc");  //验证完成后排序，将错误的信息显示在上面
	$("#DisplayMsg").html("共验证 "+actionListObj.getRows().length+" 记录，失败<font color='red'> "+failNum+"</font> 记录");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("处理中……");
}


/**
 * [获取指定状态的记录总数]
 * @param    {[int]}    Status [0:未验证  1:验证成功  2:导入成功  -1:验证失败  -2:导入失败]
 * @return   {[int]}           [记录总数]
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
 * [导入行数据]
 */
function import_rowData(job, rowData,index,failNum,successNum,needNum){
	var data=rowData[index];
	if(data.TStatus==1){  //验证成功的才能执行导入
		var instring=valid_obj(job, data, index);
		if(instring==""){
			failNum++;
			data.TStatus=-1;
		}else{
			console.log("导入，共"+index+"");
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
			$("#LoadMsg").html("导入数据：<font color='red'> "+(failNum+successNum)+"</font>/"+needNum);
		}
		setTimeout(function(){import_rowData(job, rowData,index+1,failNum,successNum,needNum);},0);
	}

}

/**
 * [导入完成事件]
 */
function afterImport(failNum,successNum){
	sortTStatus("asc");  //导入完成后排序，将错误的信息显示在上面
	$("#DisplayMsg").html("共导入 "+successNum+" 记录，失败<font color='red'> "+failNum+"</font> 记录");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("处理中……");
}


//去除字符串的空格
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

//去除字符串两端的空格
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
用途：检查输入是否正确的电话和手机号 
输入： 电话号
value：字符串 
返回： 如果通过验证返回true,否则返回false 
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
