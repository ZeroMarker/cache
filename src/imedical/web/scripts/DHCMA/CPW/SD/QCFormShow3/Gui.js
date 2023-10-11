//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj=objScreen
	obj.QCID=QCID
	obj.OperStartTime=""
	var flowInd=-1,formHTML=""
	while (1) {
		var ret=$m({
			ClassName:'DHCMA.CPW.SDS.QCEntitySrv',
			MethodName:'GetQCHtml',
			aQCID:obj.QCID,
			aflowInd:flowInd
		},false)
		var retArr=ret.split(String.fromCharCode(1))
		var flowHTML=retArr[1]
		formHTML=formHTML+flowHTML
		var flowInd=retArr[0]
		if (flowInd=="999") {
			break;	
		}
	}
	$("body").append(formHTML);
	obj.VerID=VerID
	obj.curStatus=CurStatus
	//是否启用输入框监听，防止初始赋值就进行监听
	obj.addListener=0
	//缓存评分表打分内容以及当前评分关联质控项目
	obj.ScoreArr=new Array();
	obj.EQCItemCode=""
	//记录表单设计的分类
	ValiCat=new Array();
	//提醒内容预留div
	$('#SDNotice').html('')
	//加载排除原因填写框
	var html=""
	html+='<div id="winConfirmInfo" buttons="#dlgY-buttons" style="height:310px;width:600px;border:none;overflow:auto;padding:0;">'
	html+='<div class="hisui-layout" data-options="fit:true">'
	html+='<div style="padding:0;border:0px;">'
	html+='<table>'
	html+='<tr style="margin-top:10px">'
	html+='<td style="text-align:right;vertical-align:top;width:70px;font-weight:bold;border:none;">依据原因</td>'
	html+='<td >'
	html+='<span id="RuleDic" style="border:none;"></span>'
	html+='</td>'
	html+='</tr>'
	html+='<tr>'
	html+='<td  style="text-align:right;width:70px;font-weight:bold;border:none;">其他备注</td>'
	html+='<td>'
	html+='<textarea id="RuleResume" class="textbox" size="12" rows="2" style="width:500px;height:45px;border:none;"></textarea>'
	html+='</td>'
	html+='</tr>'
	html+='</div>'
	html+='</div>'
	html+='<div id="dlgY-buttons">'
	html+='<a id="SaveRule" class="hisui-linkbutton">提交</a>'
	html+='</div>'		
	html+='</div>'
	//评估量表div
	html+='<div id="winVal">'   
	html+='<div id="ValDic"></div>'
	html+='</div>'
	html+='<div id="tools" style="height:30px">'
	html+='<div href="#" style="float:left">得分：<span id="tScore" style="color:#5B89EB;font-size:15px;font-weight:bold;">104分<span></div>'
	html+='<div href="#" style="float:right;padding-right:20px;">'
	html+='<a href="#" id="ExitScore" class="hisui-linkbutton hover-dark">确定</a>'
	html+='</div>'
	html+='</div>'
	$("body").append(html)
	$.parser.parse();
	//初始化评估量表
	$('#winVal').dialog({
		title:"",
		closed: true,
		closable:false,
		iconCls:'icon-w-save',
		modal: true,
		center:true,
		width:'600',
		height:document.documentElement.clientHeight-20,
		onClose:function(){
			$(document.body).css({ 
			   "overflow-y":"auto" 
			 });
		},
		onBeforeOpen:function(){
			$(document.body).css({ 
			   "overflow-y":"hidden"
			 });	
		},
		buttons:'#tools'
		
	});
	//记录表单初始化数据
	obj.formdata=""
	obj.initFlg=0
	//全局变量 编辑值
	EditVal = new Array();
	EditItem = new Array();
	tdWidth=$("input").outerWidth()
	//赋值表单
	$cm({
		ClassName:'DHCMA.CPW.SDS.QCItemExecSrv',
		QueryName:'QryQCItemExec',
		MrListID:MrListID,
		aVerID:VerID,
		aQCEntityID:QCID,
		rows:1000
	},function(data) {
		obj.formdata=data
		var length=data.rows.length
		for (var i=0;i<length;i++) {
			var Code=data.rows[i].BTCode
			var Value=data.rows[i].ExecResult
			var text=data.rows[i].ExecResultText
			var EditPower=data.rows[i].EditPower
			var ItemSubCat=data.rows[i].BTItemSubCat
			var ItemCat=data.rows[i].BTItemCat
			//记录表单大类信息
			if (ValiCat.indexOf(ItemCat)<0) ValiCat.push(ItemCat);
			if (EditPower=='0') {
				$('#'+Code+"Row").css({'display':'none'})
				//判断子标题是否需要收起来
				if ($('#'+Code+"Row").prev()[0].className=='itemsubCat')
				{
					$('#'+Code+"Row").prev().css({'display':'none'})
				}
			}else{
				itemclass=$('#'+Code)[0].className
				if (itemclass.indexOf("combox")>-1){
					var multi=false
					if (itemclass.indexOf('mul')>-1) multi=true
					obj.CreatCombo(Code,multi)
					$('#'+Code).combobox('setValue',Value,text)
				}else if (itemclass=='list'){
					//给单选列表赋值
					$('[name="'+Code+'"][value="'+Value+'"]').radio('setValue', true)
				}else if (itemclass=='mullist'){
					var valArr=Value.split(',')
					//循环给多选列表赋值
					for (var j=0;j<valArr.length;j++) {
						if (valArr[j]=="") continue;
						$('[name='+Code+'][value='+valArr[j]+']').radio('setValue', true);
					}
				}else{
					$('#'+Code).val(Value)
				}	
			}
		}	
		//表单值加载完毕，启动表单事件监听！
		obj.addListener=1
		//记录数据加载完成时间，作为操作开始日期时间
		var date=new Date();
		obj.OperStartTime=Common_GetCurrDateTime(date);
	})
	//生成字典列表
	$(".mullist").each(function(i, v){
		Common_CheckboxToSDDic(v.id,v.id,1);
	})
	$(".list").each(function(i, v){
		Common_RadioToSDDic(v.id,v.id);
	 })
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


