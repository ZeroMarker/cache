var openAutPage = function(code,hospId){
	hospId = hospId||"";
	code = code||"mediway";
	websys_showModal({url:"dhc.bdp.bdp.bdpcdssdeptuseraut.csp?CDSSCodeStr="+code+"^"+hospId,width:'90%',height:'90%'});
}
$(function(){
	// ClassName:'web.DHCBL.CT.CTHospital',QueryName:'GetDataForCmb1'
	var HospData = $cm({ClassName:'web.CTHospital',QueryName:'LookUp',ResultSetType:"array"},false);
	if ($('#tCF_BSP_SYS_CDSSService').length>0) {
		$m({ClassName:"BSP.SYS.SRV.AuthItemApply",MethodName:"GetStatusHtml",AuthCode:"HIS-BSP-CDSS"},function(rtn){
        	if (rtn!=""){
	        	$(rtn).insertAfter('#EnableCDSSDiv');
	        }
        	
        });
		var disableCDSS = function (){
			//$('#GrantBtn').linkbutton('disable');
        	$('#Find').linkbutton('disable');
        	$('#EnableCDSSDiv').parent().next().html('<span style="color:red">已禁用系统的CDSS功能</span>')
		}
		var enableCDSS = function(_t){
			//$('#GrantBtn').linkbutton('enable');
            $('#Find').linkbutton('enable');
            $('#EnableCDSSDiv').parent().next().html('<span style="color:green">已启用系统的CDSS功能</span>')
		}
		//var cminfo = $.cm({dataType:"text",ClassName:"websys.hisui.ComponentUserImp",MethodName:"ColumnToJson",cmpId:54517},false);
		//eval("cminfo="+cminfo);
		var formatterHsop = function (value, rowData, rowIndex) {
			for(var i = 0; i < HospData.length; i++) {
				if (HospData[i].HIDDEN == value) {
					return HospData[i].Description;
				}
			}
			return value;
		}
		$('#tCF_BSP_SYS_CDSSService').mgrid({
			className:"CF.BSP.SYS.DTO.CDSSServiceDto",
			queryName:"Find",
			codeField:'TSrvCode',
			activeColName:'TSrvActive',
			onColumnsLoad:function(cm){
				for (var i=0;i<cm.length;i++){
					cm[i].editor ={type:'text'};
					if(cm[i]['field']=="TID"){
						cm[i].hidden = true;
					}else if(cm[i]['field']=="TSrvParam"){
						if ("undefined"==typeof cm[i].width) cm[i].width=150;
					}else if(cm[i]['field']=="TSrvURL"){
						if ("undefined"==typeof cm[i].width) cm[i].width=150;
					}else if (cm[i]['field']=="TSrvActive"){
						if ("undefined"==typeof cm[i].width) cm[i].width=60;
						cm[i].formatter = function(val,row,index){
							if (val==1) return "激活";
							else {return "禁用"}
						}
						cm[i].editor = {type:'checkbox',options:{on:1,off:0}};
					}else if(cm[i]['field']=="TSrvStDate"){
						cm[i]['hidden']=true;
						if ("undefined"==typeof cm[i].width) cm[i].width=100;
						cm[i].formatter = function(val,row,index){
							return val;
						}
						cm[i].editor ={type:'dateboxq'};
					}else if (cm[i]['field']=="TSrvHospId"){
						cm[i].formatter =formatterHsop;
						if ("undefined"==typeof cm[i].width) cm[i].width = 120;
						cm[i].editor={
							type:'combobox',
							readonly : false,
							options:{
								data:HospData,
								valueField:"HIDDEN",
								textField: 'Description',
								defaultFilter:6
							}
						}
					}
				}
				cm.push({
					field:'auth',
					title:'授权',
					width:60,
					formatter:function(value, rowData, rowIndex){
						if ('undefined'!=typeof rowData.TID && rowData.TID>0){
							return "<a class='icon icon-lock' style='width:16px;height:16px;display:block;' href='#' onclick='openAutPage(\""+rowData.TID+"\",\""+(rowData.TSrvHospId||"")+"\");return false;'></a>";
						}
					}
				});
			},
			editGrid:true,
			fit:false,
			height:500,
			key:"entt",
			fitColumns:true,
			autoSizeColumn:true,
			onClickRow:function(rowIndex,rowData){
			},
			onDblClickRow:function(rowIndex,rowData){
			},
			rownumbers:true,
			pagination:true,
			//pageSize:cminfo.pageSize==15?15:cminfo.pageSize,
			showPageList:false,
			singleSelect:true,
			url:$URL,
			onBeforeLoad:function(p){
				p.Code = $("#Code").val();
			},
			insOrUpdHandler:function(row){
				var param ={
					"dto.entt.id":row.TID,"dto.entt.SrvCode":row.TSrvCode,"dto.entt.SrvDesc":row.TSrvDesc,
					"dto.entt.SrvURL":row.TSrvURL,"dto.entt.SrvVersion":row.TSrvVersion,"dto.entt.SrvParam":row.TSrvParam,
					"dto.entt.SrvStDate":row.TSrvStDate,"dto.entt.SrvActive":row.TSrvActive,"dto.entt.SrvHospId":row.TSrvHospId
				};
				if (row.TID==""){
					if (!row.TSrvCode){
						$.messager.popover({msg:"代码不能为空！",type:'info'});
						return false;
					}
					$.extend(param,this.insReq,{
						"dto.entt.id":""
					});
				}else{
					$.extend(param,this.updReq,{
						"dto.entity.id":row.TID
					});
				}
				$cm(param,defaultCallBack);
			},
			getNewRecord:function(){
				return {TID:"",TSrvCode:"",TSrvDesc:"",TSrvURL:"",TSrvVersion:"",TSrvParam:"",TSrvStDate:"",TSrvActive:0,TSrvHospId:""};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("删除", "确定删除【"+row.TSrvCode+"】记录?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.entt.id":row.TID});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		});
		$('#tCF_BSP_SYS_CDSSService').datagrid('options').view.onAfterRender = fixTGrid;
		$(window).on('resize',fixTGrid);
		$('#Find').click(function(){
			if (!$(this).linkbutton('options').disabled){
				$('#tCF_BSP_SYS_CDSSService').datagrid('load');
			}
		});
		$('#EnableCDSSDiv').switchbox({
	        onText:'启用',
	        offText:'禁用',
	        onClass:'primary',
	        offClass:'gray',
	        animated:true,
	        size:'small',
	        onSwitchChange:function(e,obj){
	            $cm({
		        	ClassName:"CF.BSP.SYS.DTO.CDSSServiceDto",
		        	MethodName:"SetEnableCDSSFlag",
		        	Flag: obj.value===false?0:1,
		        	dataType:"text"
		        },function(rtn){
		        	var arr = rtn.split("^");
		        	if (arr[0]>=0){
			        	if (obj.value===false){
				        	disableCDSS();
			        	}else{
			        		enableCDSS();
			        	}
			        }else{
				        var nxt = $("#EnableCDSSDiv").next();
					    if (!nxt.hasClass("auth-item-apply-ing")){
					        $m({ClassName:"BSP.SYS.SRV.AuthItemApply",MethodName:"GetStatusHtml",AuthCode:"HIS-BSP-CDSS"},function(rtn){
					        	if (rtn!=""){
						        	$('#EnableCDSSDiv').find('auth-item-apply-ing').remove();
						        	$(rtn).insertAfter('#EnableCDSSDiv');
						        }
					        });
				        }
				        var fl = $('#EnableCDSSDiv').switchbox('isActive');
				        $('#EnableCDSSDiv').bootstrapSwitch('setState',!fl,true); //不再触发change事件
			        	$.messager.popover({msg:arr[1],type:'error'});
			        	return false;
			        }
		        });
	        }
	    });
		var val = $('#EnableCDSSDiv').data('val');
		if ((val+"").indexOf("^")>-1){
			$.messager.alert("提示",val.split('^')[1]);
			$('#EnableCDSSDiv').switchbox("setValue",false);
			disableCDSS();
			$('#EnableCDSSDiv').switchbox("setActive",false);
		}else{;
			$('#EnableCDSSDiv').switchbox("setValue",val==1?true:false,false);
			if (val==1) enableCDSS();
			else{disableCDSS();}
		}
	    
	    /*$("#EnableCareProKw").keywords({
            //singleSelect:true,
            onClick:function(v){console.log("点击->"+v.text)},
            onUnselect:function(v){console.log("取消选择->"+v.text);},
            onSelect:function(v){console.log("选择->"+v.text);},
            //labelCls:'red',
            items:[
                {text:'医生',id:'DOCTOR'},
                {text:'护士',id:'red2'},
                {text:'其它',id:'red3'}
            ]
        });*/
	}
})