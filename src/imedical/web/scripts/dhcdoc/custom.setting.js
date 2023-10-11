$(function(){
    if(ServerObj.SelectTitle!=''){
        $('#accMain').accordion('select',ServerObj.SelectTitle);
    }
    InitCombobox();
    InitSlider();
    InitEvent();
    InitSetting();
});
function InitCombobox()
{
    InitSingleCombo('ViewIPDocPatInfoLayOut',{
        ClassName:'web.DHCDocInPatUICommon',
        MethodName:'GetViewIPDocPatInfoLayOutJson'
    });
    InitSingleCombo('ViewOrderSort',{
        ClassName:'web.DHCDocInPatUICommon',
        MethodName:'GetViewOrderSortJson'
    });
    InitSingleCombo('ViewLocDesc',{
        ClassName:'web.DHCDocInPatUICommon',
        MethodName:'GetViewLocDescJson'
    });
    InitSingleCombo('ViewScopeDesc',{
        ClassName:'web.DHCDocInPatUICommon',
        MethodName:'GetViewScopeDescJson'
    });
    InitSingleCombo('ViewNurderBill',{
        ClassName:'web.DHCDocInPatUICommon',
        MethodName:'GetViewNurderBillJson'
    });
    InitSingleCombo('DefWard',{
        ClassName:'web.DHCDocInPatientListNew',
        MethodName:'getLinkLocByLocID',
        ALocID:session['LOGON.CTLOCID']
    },{valueField:'LocID',textField:'LocDesc',panelHeight:180,editable:true,filter: function(q, row){
        return (row['LocDesc'].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row['Alias'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
    }});
}
function InitSingleCombo(id,params,opts)
{
    var url=params.MethodName?'websys.Broker.cls':$.fn.combobox.defaults.url;
    $('#'+id).combobox($.extend({
        url:url,
        editable:false,
        panelHeight:'auto',
        onBeforeLoad:function(param){
            $.extend(param,{UserRowID:session['LOGON.USERID'],GroupRowID:session['LOGON.GROUPID'],isNurseLogin:ServerObj.isNurseLogin},params);
        }
    },opts));
}
function InitSlider()
{
    $('#TempHeightScale,#TempWidthScale').slider({    
        width:300,
        height:50,
        showTip:true,
        rule:[10,20,30,40,50,60,70,80,90],
        min:10,
        max:90,
        tipFormatter:function(value){
            return value+"%";
        },
		onChange:function(val,oldVal){
			$(this).slider('options').oldVal=oldVal;
		},
		onComplete:function(val){
			var opts=$(this).slider('options');
			if(opts.disabled&&opts.oldVal){
                var changeFun=opts.onChange;
                opts.onChange=function(){};
				$(this).slider('setValue',opts.oldVal);
                opts.onChange=changeFun;
			}
		}
    });
}
function InitEvent(){
	$('#OrderEntry input[name="TemplateRegion"]').radio({
		onChecked:function(e){
			var region=$(e.target).attr('id');
			if(['north','south'].indexOf(region)>-1){
                $('#OrderEntry #DefCollapseTemp').next().hide();
                $('#OrderEntry input[name=OrdListRegion]#'+region).radio("setValue",true);
				$('#OrderEntry input[name="OrdListRegion"]').radio('disable');
				$('#OrderEntry input[name="ExpendPage"]').radio('enable');
				$('#OrderEntry #TempHeightScale').slider('enable');
				$('#OrderEntry #TempWidthScale').slider('disable');
				if(!$('#OrderEntry input[name="ExpendPage"]:checked').size()){
                    $('#OrderEntry #OrdList').radio('setValue',true);
                }
			}else{
				$('#OrderEntry input[name="OrdListRegion"]').radio('enable');
				$('#OrderEntry input[name="ExpendPage"]').radio('disable');
                $('#OrderEntry #OrdList').radio('setValue',true);
				$('#OrderEntry #TempHeightScale').slider('disable');
				$('#OrderEntry #TempWidthScale').slider('enable');
				if(region=='window'){
					$('#OrderEntry #DefCollapseTemp').next().show();
				}else{
                    $('#OrderEntry #DefCollapseTemp').next().hide();
                }
			}
			$(e.target).radio('disable');
			$('#OrderEntry input[name="TemplateRegion"]').not(e.target).radio('enable');
		}
	})
	$('#DiagnosEntry input[name="DiagTemplateRegion"]').radio({
		onChecked:function(e){
			var region=$(e.target).attr('id');
			if(region=='window'){
				$('#DiagnosEntry #DefCollapseTemp').next().show();
			}else{
				$('#DiagnosEntry #DefCollapseTemp').next().hide();
			}
			$(e.target).radio('disable');
			$('#DiagnosEntry input[name="DiagTemplateRegion"]').not(e.target).radio('enable');
		}
	});
	$('#CMOrderEntry input[name="CNTemplateRegion"]').radio({
		onChecked:function(e){
			var region=$(e.target).attr('id');
			if(['north','south'].indexOf(region)>-1){
				$('#CNTempScale').slider('enable');
				$('#CNTempWScale').slider('disable');
                $('#CMOrderEntry #DefCollapseTemp').next().hide();
                $('#CMOrderEntry #TempHeightScale').slider('enable');
				$('#CMOrderEntry #TempWidthScale').slider('disable');
			}else{
				$('#CNTempScale').slider('disable');
				$('#CNTempWScale').slider('enable');
                $('#CMOrderEntry #TempHeightScale').slider('disable');
				$('#CMOrderEntry #TempWidthScale').slider('enable');
				if(region=='window'){
					$('#CMOrderEntry #DefCollapseTemp').next().show();
				}else{
                    $('#CMOrderEntry #DefCollapseTemp').next().hide();
                }
			}
			$(e.target).radio('disable');
			$('#CMOrderEntry input[name="CNTemplateRegion"]').not(e.target).radio('enable');
		}
	});
    InitAccScroll();
}
function InitAccScroll()
{
    var panels=$('#accMain').accordion('panels');
    $.each(panels,function(){
        var index=$('#accMain').accordion('getPanelIndex', $(this));
        $(this).on("mousewheel DOMMouseScroll",'.layout-panel-center>.panel-body', function (event) {
            var delta = (event.originalEvent.wheelDelta && (event.originalEvent.wheelDelta > 0 ? 1 : -1)) ||  // chrome & ie
                        (event.originalEvent.detail && (event.originalEvent.detail > 0 ? -1 : 1));              // firefox
            var scrollHeight=this.scrollHeight;
            var clientHeight=this.clientHeight;
            var scrollTop=this.scrollTop;
            if((delta>0)&&(scrollTop<1)){
                if(panels[index-1]){
                    $('#accMain').accordion('select',index-1);
                }
            }else if((delta<0)&&((scrollHeight-clientHeight-scrollTop))<1){
                if(panels[index+1]){
                    $('#accMain').accordion('select',index+1);
                }
            }
        });
    });
}
function GetTypeObj()
{
    return ServerObj.GroupRowId==''?{Type:'User.SSUser',Value:session['LOGON.USERID']+'|'+session['LOGON.GROUPID']}:{Type:'User.SSGroup',Value:ServerObj.GroupRowId};
}
function InitSetting()
{
    var TypeObj=GetTypeObj();
    $('body').find('div[id].accordion-body').each(function(){
        var target=this;
        var id=$(target).attr('id');
        $(target).find('#DefCollapseTemp').next().hide();
        $.cm({
            ClassName:'web.DHCDocConfig',
            MethodName:'GetPageSetting',
            Type:TypeObj.Type, TypeValue:TypeObj.Value, PageCode:id, HospId:ServerObj.HospID
        },function(data){
            $.each(data,function(key,value){
                if($(target).find('#'+key).size()){
                    $(target).find('#'+key).setValue(value);
                }else if((value!='')&&$(target).find('input[name="'+key+'"]').size()){
                    $(target).find('input[name="'+key+'"]#'+value).radio('setValue',true);
                }
            });
        });
    });
}
function SavePanel(panelId){
    var SaveObj=new Object();
    var radioArr=new Array();
    $('#'+panelId).find('[id]').each(function(){
        var id=$(this).attr('id');
        if(id=='') return true;
        if($(this).attr('type')=='radio'){
            var name=$(this).attr('name');
            if(name=='') return true;
            if(radioArr.indexOf(name)==-1){
                radioArr.push(name);
                SaveObj[name]=$("input[name='"+name+"']:checked").attr('id')||'';
            }
        }else{
            SaveObj[id]=$(this).getValue();
        }
    });
    var TypeObj=GetTypeObj();
    var ret=$.cm({
        ClassName:'web.DHCDocConfig',
        MethodName:'SetPageSetting',
        Type:TypeObj.Type, TypeValue:TypeObj.Value, PageCode:panelId, Data:JSON.stringify(SaveObj), HospId:ServerObj.HospID,
        dataType:'text'
    },false);
    if(ret=='0'){
        $.messager.popover({msg:'保存成功!',type:'success'});
    }else{
        $.messager.alert('提示','保存失败:'+ret,'error');
    }
}
function ResetPanel(panelId){
    var title=$('#'+panelId).panel('options').title;
    $.messager.confirm('提示',$g('确定重置"')+$g(title)+$g('"的设置?'),function(r){
        if(r){
            var TypeObj=GetTypeObj();
            $.cm({
                ClassName:'web.DHCDocConfig',
                MethodName:'SetPageSetting',
                Type:TypeObj.Type, TypeValue:TypeObj.Value, PageCode:panelId, Data:"{}", HospId:ServerObj.HospID,
                dataType:'text'
            },false);
            $.messager.popover({msg:'重置成功!',type:'success'});
            var url='dhcdoc.custom.setting.csp?GroupRowId='+ServerObj.GroupRowId+'&SelectTitle='+title;
            location.href=(typeof websys_writeMWToken=='function')?websys_writeMWToken(url):url;
        }
    });
}