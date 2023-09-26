/// Creator: bianshuai
/// CreateDate: 2015-04-23
/// Descript: 药学监护基础数据维护

var url="dhcpha.clinical.action.csp";
$(function(){

	///初始化选项卡
	$("#tabs").tabs({
		border:false,
	    fit:"true", 
	    onSelect:function(title){}
	});
	
	$('li').bind('click',function(){
		var ListTitle=$(this).text();
		addAutoTab(ListTitle.replace(/[ ]/g,""));
	})
})

/// 添加选项卡
function addAutoTab(tabTitle){

    if ($('#tabs').tabs('exists',tabTitle)){
        $('#tabs').tabs('select',tabTitle);
    }
    else{
        switch(tabTitle){
	        case "学科分类":
				maintab="dhcpha.clinical.pharcarediscat.csp";
				break;
            case "监护级别":
				maintab="dhcpha.clinical.pharcaremonlevel.csp";
				break;
			case "纳入标准":
				maintab="dhcpha.clinical.pharcaremonscope.csp";
				break;
			case "监护项目":
				maintab="dhcpha.clinical.pharcaremonitem.csp";
				break;
			case "咨询类别":
				maintab="dhcpha.clinical.questions.csp";
				break;
			case "问题类型":
				maintab="dhcpha.clinical.quetype.csp";
				break;
			case "回复依据":
				maintab="dhcpha.clinical.consultbasis.csp";
				break;
			case "特殊人群":
				maintab="dhcpha.clinical.specialcrowd.csp";
				break;
			case "咨询方式":
				maintab="pha.cpw.v2.consways.csp";
				break;
			case "咨询身份":
				maintab="pha.cpw.v2.considen.csp";
				break;
			case "服务时间":
				maintab="pha.cpw.v2.constime.csp";
				break;
			case "专业方向":
				maintab="dhcpha.clinical.profdirection.csp";
				break;
			case "用药建议模板数据维护":
				maintab="dhcpha.clinical.drgsugdic.csp";
				break;
			case "药品指标关联维护":
				maintab="dhcpha.clinical.drugindex.csp";
				break;
			case "事件名称":
				maintab="dhcpha.clinical.adrevent.csp";
				break;
			case "患者相关":
				maintab="dhcpha.clinical.adrpatimpoinfo.csp";
				break;
			case "用药原因":
				maintab="dhcpha.clinical.adrreasonformed.csp";
				break;
			case "填报意愿":
				maintab="dhcpha.clinical.adrwishes.csp";
				break;
			case "报告状态":
				maintab="dhcpha.clinical.adrstatus.csp";
				break;
			case "流程定义":
				maintab="dhcpha.clinical.adrprocess.csp";
				break;
			case "主题字典":
				maintab="dhcpha.clinical.addtheme.csp";
				break;
			case "函数维护":
				maintab="dhcpha.clinical.addfunlibrary.csp";
				break;
			case "项目维护":
				maintab="dhcpha.clinical.addfunlibitem.csp";
				break;
			case "指导范围":
				maintab="dhcpha.clinical.guiscope.csp";
				break;
			default:
				maintab="";
		}
		
		if(maintab==""){
			$.messager.alert('提示','菜单不存在,请联系管理员！','warning');
			return;
		}
        var content = '<iframe scrolling="auto" frameborder="0"  src="'+maintab+'" style="width:100%;height:100%;"></iframe>';
        $('#tabs').tabs('add',{
            title : tabTitle,
            content : content,
            closable : true
        });
    }
}