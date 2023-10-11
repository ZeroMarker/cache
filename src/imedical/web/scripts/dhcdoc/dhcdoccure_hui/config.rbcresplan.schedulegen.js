var PageLogicObj={
	m_TreeJsonCSP:'./dhcdoc.cure.query.tree.easyui.csp',
	m_ClassName:'DHCDoc.DHCDocCure.RBCResPlan',
	m_QueryName:'FindScheduleTemp',
	m_ComboJsonCSP:'./dhcdoc.cure.query.combo.easyui.csp',
};
function InitHospList()
{
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SerchLoc,#SerchDoc").searchbox('setValue',"");
		$("#StartDate,#EndDate").datebox('setValue',"");
		$("#chkSel").checkbox('uncheck');
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}

$(function(){
	//初始化
	if(ServerObj.ForLocID==""){
		InitHospList();
	}else{
		Init();	
	}
	
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	document.onkeydown = Doc_OnKeyDown;
})
function Init(){
	//InitSingleCombo('ScheduleLines','RSLRowId','Desc','RBScheduleLinesList');
	InitDocTree();
}
function Doc_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
   if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
}

function InitEvent(){
	$("#BtnGeneSched").click(Create_Click);
	$(".searchbox-text").keyup(function(){ 
		setTimeout(function(){
			InitDocTree(); 
		},50)
	});
	//$("#SelectAll").click(SelectAll_Click)
	$HUI.checkbox("#chkSel",{
		onCheckChange:function(e,value){
			var ops=$('#DocTree').tree("getChildren");
			if (value) {
				$.each(ops, function(index, obj) {
					$("#DocTree").tree("check", obj.target)
				})
			}else{
				$.each(ops, function(index, obj) {
					$("#DocTree").tree("uncheck", obj.target)
				})
			}
		}
	});
}
function PageHandle(){
	
}
function InitSingleCombo(id,valueField,textField,Query){
	var HospID=Util_GetSelHospID();
	var ComboObj={
		editable:true,
		panelHeight:200,
		multiple:false,
		mode:"local",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	url:$URL+'?ClassName='+PageLogicObj.m_ClassName+'&QueryName='+Query+"&HospId="+HospID+ "&ResultSetType=array",
	  	filter: function(q, row){
			var opts = $(this).combobox('options');
			return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row['code'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	};
	if(id=="ScheduleLines"){
		$.extend(ComboObj,{
			editable:false,
			onLoadSuccess:function(){
				if (ServerObj.ScheduleLinesRowId!=""){
					$("#ScheduleLines").combobox('select',ServerObj.ScheduleLinesRowId); 
				}else{
					var data=$("#ScheduleLines").combobox('getData');
					if (data.length>0){
						var DefaultRowid="";
						for (var i=0;i<data.length;i++){
							if (data[i]['Default']=="Y") {
								DefaultRowid=data[i]['RSLRowId'];
								break;
							}
						}
						if (DefaultRowid=="") DefaultRowid=data[0]['RSLRowId'];
						$("#ScheduleLines").combobox('select',DefaultRowid); 
					}
				}
			},
			onSelect:function(record){
				InitDocTree();
			}
		});
	}
	$("#"+id).combobox(ComboObj);
}
function Create_Click()
{
	var StDate=$('#StartDate').datebox('getValue');
	if (StDate==""){
		$.messager.alert("提示","请输入开始日期!","info",function(){
			$('#StartDate').next('span').find('input').focus();
		});	
		return false;
	}
	var EdDate=$('#EndDate').datebox('getValue');
	if (EdDate==""){
		$.messager.alert("提示","请输入结束日期!","info",function(){
			$('#EndDate').next('span').find('input').focus();
		});	
		return false;
	}
	var schstr="";
	var nodeArr=$('#DocTree').tree('getChecked');
	for(var i=0;i<nodeArr.length;i++){
		if(nodeArr[i].children) continue;
		var parNode=$('#DocTree').tree('getParent',nodeArr[i].target);
		if(schstr=="") schstr=parNode.id+"|"+nodeArr[i].id;
		else schstr+="^"+parNode.id+"|"+nodeArr[i].id;
	}
	$.messager.defaults = { ok: "是", cancel: "否" };
	var info="您确定要生成 "+StDate+" 到 "+EdDate+" 的<font color=red>";
	if(schstr=="") info+="全部"
	else info+="指定选择"
	info+="</font>的排班吗？";
	$.messager.confirm("提示",info , 
		function (r) {
            if (r) {
	            var HospID=Util_GetSelHospID();
				var value=tkMakeServerCall('DHCDoc.DHCDocCure.RBCResPlan','GenCreateResApptSchulde',StDate,EdDate,schstr,session['LOGON.USERID'],HospID,ServerObj.ForLocID);
				if(value=="0"){
					$.messager.popover({msg: "生成资源计划成功!",type:'success',timeout: 3000})
					//window.parent.destroyDialog('GenSche');
				}else{
					var err=""
					if(value=="1000") err="请检查排班模板数据是否存在问题"
					$.messager.alert('提示',"生成资源计划失败!"+err,"error");
				}
            }
    });
}
function InitDocTree(){
	var HospID=Util_GetSelHospID();
	$('#DocTree').tree({    
		url: PageLogicObj.m_TreeJsonCSP,
		checkbox:true,
		onBeforeLoad:function(node, param){
			param.TreeFieldStr="LocDesc^ResDesc";
			param.LocRowid=ServerObj.ForLocID;
			param.idFieldStr="LocRowid^DocRowid";
			param.ILocDesc=$.trim($($(".searchbox-text")[0]).val());
			param.IDocDesc=$.trim($($(".searchbox-text")[1]).val());
			param.Closed=3;
			param.HospId=HospID;
			param.ClassName=PageLogicObj.m_ClassName;
			param.QueryName=PageLogicObj.m_QueryName;
		},
		onLoadSuccess:function(node, data){
			if ($.trim($($(".searchbox-text")[1]).val())==""){
				$('#DocTree').tree("collapseAll");  
			}
		},
		onLoadError:function(){
			alert('Init Tree Error');
		}
	});
}
/*function SelectAll_Click(e) {
	var ops=$('#DocTree').tree("getChildren")
	$.each(ops, function(index, obj) {
		$("#DocTree").tree("check", obj.target)
	})
}*/
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}