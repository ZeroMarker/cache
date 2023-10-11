var LookUpUser = function(str){}
var LookUpGroup = function(str){}
var LookUpLoc = function(str){}
var CCRecipientsJObj = $("#CCRecipients");
var preUserKeyWord = "";
// 2016-01-04,06/08/65
$(function(){
	var $URL=(typeof $URL=="undefined")?"jquery.easyui.querydatatrans.csp":$URL;
	/*
	$('#SelectUser').keyup(function(event){
		var that = $(this);
		var kw = that.val();
		if (kw.length>0 && preUserKeyWord != kw){
			preUserKeyWord = kw;
			$("#SelectUser").unautocomplete();
			$.ajaxRunServerQuery({ClassName:'web.SSUser',QueryName:'LookUp',desc:kw},function(data){
				if (data && data.total>0){
					var d = data.rows;
					$('#SelectUser').autocomplete(d,{
						formatItem:function(row,i,max){
							return "<span style='width:100px'>"+ row.Code +"</span><span style='width:120px;float:right;'>" + row.Description + "</span>"; 
						},
						formatMatch:function(row, i, max){
							return row.Description;
						},
						formatResult: function(row) {
							return row.Description;
				        },
						matchContains:false,
						max: 10,
						minChars:1,
						multiple:false,	 //true--->mult yy@dhcc.com.cn,xx@dhcc.com.cn,
						scroll: false
					}).result(function(event,data,format){
				  		CCRecipientsJObj.append("<option value='"+data.HIDDEN+"'>"+data.Description+"</option>");
				  		$(this).val("");
					});
				}
			});
		}
	});*/
	var autoParam = {
		formatItem:function(row,i,max){
			return "<span style='width:100px'>"+ row.Code +"</span><span style='width:120px;float:right;'>" + row.Description + "</span>"; 
		},formatMatch:function(row, i, max){
			return row.Description;
		},
		matchContains:true,
		max: 10,
		minChars:1,
		multiple:false,	/*true--->mult yy@dhcc.com.cn,xx@dhcc.com.cn,*/
		scroll: false
	}
	function createUserComplete(d){
		$('#SelectUser').autocomplete(d,autoParam).result(function(event,data,format){
	  		CCRecipientsJObj.append("<option value='"+data.HIDDEN+"'>"+data.Description+"</option>");
	  		$(this).val("");
		});
	}
	function createGroupComplete(d){
		$('#SelectGroup').autocomplete(d,autoParam).result(function(event,data,format){
      		$.ajaxRunServerQuery({
				ClassName: 'web.SSUser',QueryName: 'FindByGroup',groupid:data.HIDDEN,rows:2000
			},function(rtn){
				var str = "";
				if (rtn && rtn.total>0){
					var dr = rtn.rows
					for(var i =0 ; i<dr.length; i++){
						str += "<option value='"+dr[i].ID+"'>"+dr[i].Name+"</option>"
					}
				}
				CCRecipientsJObj.append(str);
			})
      		$(this).val("");
		});
	}
	function createLocComplete(d){
		$('#SelectLoc').autocomplete(d,autoParam).result(function(event,data,format){
			$.ajaxRunServerQuery({
				ClassName: 'web.SSUser',QueryName: 'FindByDefaultLoc',LocID:data.HIDDEN,rows:2000
			},function(rtn){
				var str = "";
				if (rtn && rtn.total>0){
					var dr = rtn.rows
					for(var i =0 ; i<dr.length; i++){
						str += "<option value='"+dr[i].ID+"'>"+dr[i].Name+"</option>"
					}
				}
				CCRecipientsJObj.append(str);
			})
	  		$(this).val("");
		});
	}	
	/*if ("undefined" == typeof gAllUserData){
		$.ajaxRunServerQuery({ClassName:'web.SSUser',QueryName:'LookUp',rows:10000},function(data){
			if (data && data.total>0){
				gAllUserData = data.rows;
				createUserComplete(gAllUserData);
			}
		});
	}else{
		createUserComplete(gAllUserData);	
	}
	if ("undefined" == typeof gAllGroupData){
		$.ajaxRunServerQuery({ClassName: 'web.SSGroup',QueryName: 'LookUp',rows:10000},function(data){
			if (data && data.total>0){
				gAllGroupData = data.rows;
				createGroupComplete(gAllGroupData);
			}
		});
	}else{
		createGroupComplete(gAllGroupData);
	}
	if ("undefined" == typeof gAllLocData){
		$.ajaxRunServerQuery({ClassName: 'web.CTLoc',QueryName: 'LookUp',desc:"",rows:10000},function(data){
			if (data && data.total>0){
				gAllLocData = data.rows;
				createLocComplete(gAllLocData);	
			}
		});
	}else{
		createLocComplete(gAllLocData);	
	}*/
	var GlobalCCID={};
	CCRecipientsJObj.find('option').each(function(){
		GlobalCCID[$(this).attr('value')]=true;
	})
	$('#SelectUser').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype="U"
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:t.colUserName,width:200},{field:'Code',title:t.colUserCode,width:200}]],
		pagination:true
		,onSelect:function(ind,row){
			setTimeout(function(){
				if (!GlobalCCID[row.ID]){
					GlobalCCID[row.ID]=true;
					CCRecipientsJObj.append("<option value='"+row.ID+"'>"+row.Desc+"</option>");
				}
		  		
		  		$('#SelectUser').combogrid('setValue','');
		  		$('#SelectUser').combogrid('options').keyHandler.query.call($('#SelectUser')[0],'');
			},0);

		}
	})
	$('#SelectGroup').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype="G"
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:t.colGroup,width:300}]],
		pagination:true
		,onSelect:function(ind,row){
			setTimeout(function(){
				$.ajaxRunServerQuery({
					ClassName: 'web.SSUser',QueryName: 'FindByGroup',groupid:row.ID,rows:2000
				},function(rtn){
					var str = "";
					if (rtn && rtn.total>0){
						var dr = rtn.rows
						for(var i =0 ; i<dr.length; i++){
							if (!GlobalCCID[dr[i].ID]){
								GlobalCCID[dr[i].ID]=true;
								str += "<option value='"+dr[i].ID+"'>"+dr[i].Name+"</option>"
							}
							
						}
					}
					CCRecipientsJObj.append(str);
				})
		  		$('#SelectGroup').combogrid('setValue','');
		  		$('#SelectGroup').combogrid('options').keyHandler.query.call($('#SelectLoc')[0],'');
			},0);
		}
	})
	$('#SelectLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype="L"
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:t.colLocDesc,width:200},{field:'Code',title:t.colLocCode,width:200}]],
		pagination:true
		,onSelect:function(ind,row){
			setTimeout(function(){
				$.ajaxRunServerQuery({
					ClassName: 'web.SSUser',QueryName: 'FindByDefaultLoc',LocID:row.ID,rows:2000
				},function(rtn){
					var str = "";
					if (rtn && rtn.total>0){
						var dr = rtn.rows
						for(var i =0 ; i<dr.length; i++){
							if (!GlobalCCID[dr[i].ID]){
								GlobalCCID[dr[i].ID]=true;
								str += "<option value='"+dr[i].ID+"'>"+dr[i].Name+"</option>"
							}
						}
					}
					CCRecipientsJObj.append(str);
				})
		  		$('#SelectLoc').combogrid('setValue','');
		  		$('#SelectLoc').combogrid('options').keyHandler.query.call($('#SelectLoc')[0],'');
			},0);
		}
	})	
	
	
	
	$("#UpdateTCC").click(function(){
		var strArr = [];
		var tccObj = document.getElementById("CCRecipients");
		if (tccObj){
			var os = tccObj.options;
			var len = os.length;
			if (len>0) {        //length=0
				for(var i=0; i<len; i++){
					strArr.push(tccObj.options[i].value);
				}
			}	
			
			var currActionId='';
			if ($("#ccwin").data('ActionId')>0){
				currActionId=$("#ccwin").data('ActionId');
			}else{
				currActionId=$('#ActionId').val();
				
			}
				//var ActionIdObj = document.getElementById("ActionId");
				//if(ActionIdObj && ActionIdObj.value!=""){
				if(currActionId>0){
					$.ajaxRunServerMethod({ClassName:'websys.DHCMessageActionTypeMgr',MethodName: 'SaveUCC',Id:currActionId,UserIds:strArr.join("^")},function(data){
						if (data==0){
							$.messager.alert(t['tip'],t["succ"]);
							$("#ccwin").window("close");
							$("#tDHCMessageActionType").datagrid("reload");
						}else{
							$.messager.alert(t['tip'],t["fail"]+data); 
						}
					});
				}
			//}else{
			//	$.messager.alert(t['tip'],t["tccnull"]); 
			//}
		}
	});
	/*
	$("#DelTCC").click(function(){
		var tccObj = document.getElementById("CCRecipients");
		if (tccObj){
			var os = tccObj.options;
			var index = tccObj.selectedIndex;
			if (index>-1) {
				os.remove(index);
			}else{
				$.messager.alert(t['tip'],t["tccnull"]); 
			}
		}
	});
	*/
	$("#DelTCC").click(function(){
		$('#CCRecipients option:selected').each(function(){
			delete GlobalCCID[$(this).attr('value')];
			$(this).remove();
		})
	});
	$("#ClearTCC").click(function(){
		GlobalCCID={};
		CCRecipientsJObj.empty();
	});
	$("#CloseTCC").click(function(){
		$("#ccwin").window("close");
	});
})	
