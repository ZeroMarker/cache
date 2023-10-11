/**
 * 院外人员导入界面  DHCPEImportDailyPersonLisInfo.js
 * @Author   wangguoying sunxintao
 * @DateTime 2023-01-15
 */

var interval_num=9;  //进度条刷新频率 每interval_num条记录刷新一次
var aCity={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"}
var editRows=new Array();  //编辑的行索引记录
/**定义数组删除函数**/
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
			{field:'TOperate',title:'操作',width:'60',align:"center",
				formatter:function(value,row,index){
					return "<a href='#' onclick='edit_row(\""+index+"\",this)'>\
					<img style='padding-top:4px;' title='修改记录' alt='修改记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\
					</a>\
					<a href='#' onclick='delete_row(\""+index+"\",\"\")'>\
					<img style='margin-left:8px; padding-top:4px;' title='删除记录' alt='删除记录' src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/>\
					</a>";
				}
			},
			{field:'TStatus',title:'状态',width:'60',sortable:'true',align:"center",
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
			//{field:'TTeam',width:'80',title:'分组名',editor:'text'},
			//{field:'TRegNo',width:'100',title:'登记号',editor:'text'},
			//{field:'TName',width:'100',title:'姓名',editor:'text'},
			//{field:'TIDCard',width:'180',title:'身份证号',editor:'text'},
			{field:'TTipMsg',title:'行提示信息',hidden:'true'}
		]],
		columns:[[
			{field:'TPreIADM',align:"center",title:'预约id',editor:'text'},
			{field:'TPAADM',title:'就诊id',editor:'text'},
			{field:'TADMDate',title:'体检日期',editor:'text'},
			{field:'TPatName',title:'姓名',editor:'text'},
			{field:'TPatSex',title:'性别',editor:'text'},
			{field:'TPatAge',title:'出生日期',editor:'text'},
			{field:'TPatIDCard',title:'身份证号',editor:'text'},
			{field:'TPatTel',title:'电话',editor:'text'},
			{field:'TLisStr',title:'检验医嘱串',editor:'text'},
		]],
		data: {"total":0,"rows":[]},
		fit:true,
		rownumbers:true,
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
		},
		toolbar:[
		{
			iconCls:'icon-add',
			text:'新增行',
			handler:function(){
				add_row();
			}
		},{
			iconCls:'icon-cancel',
			text:'删除【验证失败】记录',
			handler:function(){
				delete_row("",-1);
			}
		},{
			iconCls:'icon-cancel',
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
		}]
	});

/**
 * [行操作]
 * @param    {[int]}    index [行索引]
 * @param    {[object]}    t     [按钮对象]
 * @Author   wangguoying
 * @DateTime 2020-05-15
 */
function edit_row(index,t){
	if(editRows.indexOf(index)>-1){
		t.children[0].alt="修改记录";
		t.children[0].title="修改记录";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png";
		actionListObj.endEdit(index);
		editRows.remove(index);
		var data=actionListObj.getRows();
		data[index].TStatus=0;
		data[index].TTipMsg="";
		actionListObj.loadData(data);
		$("#DisplayMsg").html("编辑 1 记录，当前共 "+data.length+" 记录");
	}else{
		t.children[0].alt="保存记录";
		t.children[0].title="保存记录";
		t.children[0].src="../scripts_lib/hisui-0.1.0/dist/css/icons/save.png";
		actionListObj.beginEdit(index);
		editRows.push(index);
	}
}





/**
 * [状态列冒泡排序]
 * @param    {[string]}    order [asc:升序  desc:降序]
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
 * [加载Excel数据]
 * @Author   wangguoying
 * @DateTime 2020-04-28
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
 * @param    {JsonArray}    excelArr [Excel数据]
 * @Author   wangguoying
 * @DateTime 2020-04-28
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
 * @param    {[JSONArray]}    excelArr [Excel数据]
 * @param    {[int]}    i        [description]
 * @param    {[Object]}    OldData  [DataGrid 数据包]
 * @Author   wangguoying
 * @DateTime 2020-04-30
 */
function setData(excelArr,i,OldData){
	var obj=excelArr[i];
	var jsonObj=new Object();
	jsonObj.TStatus=0;
	var PreIADM="";
	if(obj.预约id) PreIADM = StringIsNull(obj.预约id);
	jsonObj.TPreIADM=PreIADM;								//TName1
	var PAADM ="";
	if(obj.就诊id) PAADM = StringIsNull(obj.就诊id);
	jsonObj.TPAADM=PAADM;				//RegNo2
	
	var ADMDate ="";
	if(obj.体检日期) ADMDate = StringIsNull(obj.体检日期);
	jsonObj.TADMDate=ADMDate;

	var PatName="";
	if(obj.姓名) PatName = StringIsNull(obj.姓名);
	jsonObj.TPatName=PatName; 				//Name3
	
	var PatSex="";
	if(obj.性别) PatSex = StringIsNull(obj.性别);
	jsonObj.TPatSex=PatSex; 
	
	
	var PatAge="";
	if(obj.出生日期) PatAge = StringIsNull(obj.出生日期);
	jsonObj.TPatAge=PatAge; 				
    
    
    var PatIDCard="";
	if(obj.身份证号) PatIDCard = StringIsNull(obj.身份证号);
	jsonObj.TPatIDCard=PatIDCard;  
	
	
	 var PatTel="";
	if(obj.电话) PatTel = StringIsNull(obj.电话);
	jsonObj.TPatTel=PatTel;  
    
     var LisStr="";
	if(obj.检验医嘱串) LisStr = StringIsNull(obj.检验医嘱串);
	jsonObj.TLisStr=LisStr;  

	
	OldData.rows.push(jsonObj);
	
	if(i==(excelArr.length-1)){
		actionListObj.loadData(OldData);
		afterFill(excelArr.length);
	}else{
		if(i%interval_num==0){
			$("#LoadMsg").html("填充数据：<font color='red'> "+(i+1)+"</font>/"+excelArr.length);
		}
		setTimeout(function(){setData(excelArr,i+1,OldData);},0);
	}
}


/**
 * [填充数据完成事件]
 * @param    {[int]}    length [读取总记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterFill(length){
	console.log("填充完成："+new Date());
	$("#DisplayMsg").html("本次加载<font color='red'> "+length+"</font> 记录，当前共<font color='red'> "+actionListObj.getRows().length+"</font> 记录");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("处理中……");
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
 * @param    {[int]}    job [进程号]
 * @param    {[array]}    rowData [表格数据包]
 * @param    {[int]}    index   [索引坐标]
 * @param    {[int]}    failNum   [验证失败记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
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
 * @param    {[object]}    obj   [行数据]
 * @param    {[int]}    index [行索引]
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
		obj.TTipMsg="姓名为空";
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
		obj.TTipMsg="检验串为空";
		return "";
	}
	
	IInString=IInString+"^"+(index+1);    //行号放到最后
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
 * [验证完成事件]
 * @param    {[int]}    failNum   [验证失败记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
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
 * [导入行数据]
 * @param    {[int]}    job        [进程号]
 * @param    {[object]}    rowData    [表格数据包]
 * @param    {[index]}    index      [行索引]
 * @param    {[int]}    failNum    [失败记录数]
 * @param    {[int]}    successNum [成功记录数]
 * @param    {[int]}    needNum    [应导入总数]
 * @Author   wangguoying
 * @DateTime 2020-05-12
 */
function import_rowData(job, rowData,index,failNum,successNum,needNum){
	var importRet=tkMakeServerCall("web.DHCPE.SecretPE","Main",job);
	$('#Loading').fadeOut('fast');
	alert("导入完成");
	return false;	
	
	var data=rowData[index];
	if(data.TStatus==1){  //验证成功的才能执行导入
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
			$("#LoadMsg").html("导入数据：<font color='red'> "+(failNum+successNum)+"</font>/"+needNum);
		}
		setTimeout(function(){import_rowData(job, rowData,index+1,failNum,successNum,needNum);},1000);
	}

}

/**
 * [导入完成事件]
 * @param    {[int]}    failNum   [导入失败记录数]
 * @param    {[int]}    successNum   [导入成功记录数]
 * @Author   wangguoying
 * @DateTime 2020-05-08
 */
function afterImport(failNum,successNum){
	sortTStatus("asc");  //导入完成后排序，将错误的信息显示在上面
	$("#DisplayMsg").html("共导入 "+successNum+" 记录，失败<font color='red'> "+failNum+"</font> 记录");
	$('#Loading').fadeOut('fast');
	$("#LoadMsg").html("处理中……");
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
			$.messager.confirm("提示","清楚全部记录？",function(r){
				if(r){
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
function add_row(){
	actionListObj.appendRow({TStatus:0});
	$("#DisplayMsg").html("新增 1 记录，当前共 "+actionListObj.getRows().length+" 记录");
}


function KillImportGlobal(job)
{
	var ReturnValue=tkMakeServerCall("web.DHCPE.ImportGInfo","KillImportGlobal",job);
	
	return ReturnValue;
}



//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
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
		//alert("输入的不是数字?");
		return "";
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {//alert("身份证号输入的数字位数不对?");
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
			//alert("输入的身份证号 "+ a[0] +" 里出生日期不对?");
			
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
			SexNV="男";
		}
		else
		{
			SexNV="女";
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
       // 开始日期的逻辑判断??是否为合法的日期 
       var array = str.split('-'); 
       var date = new Date(array[0], parseInt(array[1], 10) - 1, array[2]); 
       if(!((date.getFullYear() == parseInt(array[0], 10)) 
           && ((date.getMonth() + 1) == parseInt(array[1], 10)) 
           && (date.getDate() == parseInt(array[2], 10)))) 
       { 
           // 不是有效的日期 
           return false; 
       } 
       return true; 
   } 

   // 日期格式错误 
   return false; 
} 
function isCardID(sId){
 var iSum=0 ;
 var info="" ;
 if(sId=="") return true;
 if(!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误";
 sId=sId.replace(/x$/i,"a");
 if(aCity[parseInt(sId.substr(0,2))]==null) return "你的身份证地区非法";
 sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));
 var d=new Date(sBirthday.replace(/-/g,"/")) ;
 if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))return "身份证上的出生日期非法";
 for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;
 if(iSum%11!=1) return "你输入的身份证号非法";
 //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"男":"女");//此次还可以判断出输入的身份证号的人性别
 return true;
} 