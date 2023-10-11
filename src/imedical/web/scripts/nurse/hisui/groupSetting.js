var proObj = "",hospComp="",hospID = session['LOGON.HOSPID'],userID=session['LOGON.USERID'],nurseStr="";
var curGroupedBeds=[]; // 存当前组已分床位
var allGroupedBeds=[]; // 存所有已分组床位
var setDataGrid;
$(function() {
	var wardid=session['LOGON.WARDID'];	
	hospComp = GenHospComp("Nur_IP_WardProGroup",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		getSwitchFlag();
		$('#form').form("load",{
			Rowid: "",
			Ward:"",
			Code: "",
			Name: "",
			Nurse:[]	
		});
		nurseStr="";
		// 获取病区列表
		var wardid=$("#ward").combogrid("getValue")
    	getWardData(wardid,"");
    	GetUngroupedMainNurses("",wardid,"");    
    	reloadDataGrid(wardid,"","","Y");
	}  ///选中事件
	
	$HUI.combogrid('#_HospList',{disabled:wardid ? true : false,})
	
	// 获取病区列表
    getWardData(wardid,"");
    GetUngroupedMainNurses("",wardid,""); 
    initTable();    
    reloadDataGrid(wardid,"","","Y");
	
    // 护理分组权限
    getSwitchFlag();
    
    if(!wardid){
	    $("#switch").show();
	}
    
    
	// 默认激活
	$("#active").checkbox("check");	
	
	// 选择责组床位
	$("body").on("click",".edit-area .beds li",function(){
		$(this).toggleClass("active");	
	});
})

// 护理分组开关
function onSwitchChange(e,obj){
	$.m({
		ClassName:"Nur.NIS.Service.Base.GroupSettingV2",
		MethodName:"SwitchSetting",
		flag:obj.value ? "Y" : "N",
		hospID:hospID
	},function testget(result){
		if(result == "0"){
			$.messager.popover({msg:"分组权限保存成功！", type:'success'});										
		}
	})
}

function getWardData(wardid,warddesc) {
    $HUI.combogrid("#ward", {
	    idField: "wardid",
	    textField: "warddesc",
	    selectOnNavigation: false,
	    panelHeight: "260",
	    mode:'remote',
	    delay:500,
	    url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew",
	    columns: [[
			{field:'warddesc',title:'病区名称',width:210}
		]],
	    editable: true,
	    disabled:session['LOGON.WARDID'] ? true : false,
	    onClickRow: function (index,record) {
		    nurseStr="";
        	$('#form').form("load",{
				Rowid: "",
				Code: "",
				Name: ""	
			});
        	GetUngroupedMainNurses("",record.wardid,"");
        	searchGroup();
        	getBedList("","",record.wardid);	        
	    },
	    onBeforeLoad:function(param){
		    if(warddesc!=""){
				param['q']=warddesc;
				warddesc=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{desc:desc,hospid:$HUI.combogrid('#_HospList').getValue(),bizTable: "Nur_IP_WardProGroup"});
		},
		onLoadSuccess:function(){
			if(wardid){
				$(this).combogrid('setValue', wardid);
				wardid="";	
			}else{
				nurseStr=""
				GetUngroupedMainNurses("","","");
			}	
		}
	});
}

// 获取病区未分组的主管护士，包含选中的激活行的护士及所有未激活行的护士
function GetUngroupedMainNurses(rowID,wardid,nurseName){
	$cm({
            ClassName: "Nur.NIS.Service.Base.GroupSettingV2",
            QueryName: "GetUngroupedMainNurses",
            wardID: wardid,
            hospID: hospID,
            rowID:rowID
        },
        function (obj) {
            var nurseIDStr = "";
            $HUI.combobox("#nurse", {
                valueField: "ID",
                textField: "name",
                multiple: true,
                selectOnNavigation: true,
                panelHeight: "210",
                editable: true,
                data: obj.rows,
                formatter:function(row){  
					var rhtml;
					if(row.selected==true){
						rhtml = row.name+"<span id='i"+row.ID+"' class='icon icon-ok'></span>";
					}else{
						rhtml = row.name+"<span id='i"+row.ID+"' class='icon'></span>";
					}
					return rhtml;
				},
                onChange: function (newval,oldval) {
                    $(this).combobox("panel").find('.icon').removeClass('icon-ok');
					for (var i=0;i<newval.length;i++){
						$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
					}
					nurseStr=newval.join("@");                 
                },
                onLoadSuccess:function(data){
	                // 选中未激活责组，回显责组护士时，判断是否已分管其他激活组，是则提示，并且责组护士框不显示该护士
	                if(nurseStr!="" && data.length > 0){
		                var nurseArr=[];
						nurseStr=nurseStr!="" ? nurseStr[nurseStr.length-1]=="@" ? nurseStr.substr(0,nurseStr.length-1) : nurseStr : nurseStr;
		 				nurseArr=nurseStr!="" ? nurseStr.split("@") : nurseStr;
		 				var nameArr=nurseName ? nurseName.split(";") : [];
		 				var newArr=[];
		 				data.forEach(function(val,index){
			 				if(nurseArr.indexOf(val.ID)>-1){
				 				var index2=nurseArr.indexOf(val.ID)
				 				nurseArr.splice(index2,1)
				 				nameArr.splice(index2,1);
				 				newArr.push(val.ID);	
				 			}	
			 			})
		            	$(this).combobox('setValues', newArr);
		            	nurseStr=newArr.join("@");
		            	if(nameArr.length>0){
			            	$.messager.popover({ msg: '护士 '+nameArr.join(" ")+' 已分管其他责组或未激活！', type:'error' });
    						return false;
			            }               
		            }	                
	            } 
            });
        }
    );
}

// 初始化table
function initTable(){
    var setColumns = [[
    	{field:'code',title:'责组代码',width:80},  
    	{field:'desc',title:'责组名称',width:100}, 
    	{field:'warddesc',title:'病区',width:150},   
    	{field:'nurseName',title:'责组护士',width:200},
    	{field:'bedNums',title:'分组床位数',width:80},
    	{field:'active',title:'激活',width:60,formatter:function(value, row, index){
        	return value == "Y" ? $g("是") : $g("否")	
        }}
	]];
	setDataGrid = $('#groupGrid').datagrid({
		fit : true,
		columns :setColumns,
		toolbar:"#toolbar",
		idField:"rowid",
		pagination : true,  //是否分页
		pageSize: 15,
		pageList : [15,30,50],
		singleSelect : true,
		loadMsg : '加载中..', 
		onClickRow:function(rowIndex, rowData){
			// 选中行回显表单数据
			var rowID=$.trim($("#rowid").val());
			nurseStr=rowData.nurseId;
			if(rowID!=rowData.rowid){
				getWardData(rowData.wardid,rowData.warddesc)
				GetUngroupedMainNurses(rowData.rowid,rowData.wardid,rowData.nurseName);
				// 获取右侧床位列表
				getBedList(rowData.rowid,rowData.desc,rowData.wardid);
			}						
		 	$('#form').form("load",{
		 		Rowid: rowData.rowid,
		 		Ward:rowData.wardid,
		 		Code: rowData.code,
		 		Name: rowData.desc	
	 		});
	 		if(rowData.active == "Y"){
		 		$("#active").checkbox("check");	
		 	}else{	
			 	$("#active").checkbox("uncheck");	
			}				
		}   
	}); 
}

// 列表数据加载
function reloadDataGrid(wardid,code, name, avtiveFlag,flag)
{
	if(!flag) $("#rowid").val("");
	$.cm({
		ClassName:"Nur.NIS.Service.Base.GroupSettingV2",
		QueryName:"WardProGroupList",
		wardid:wardid,
		groupCode:code,
		groupDesc:name,
		activeFlag:avtiveFlag,
		nurIds:flag ? "" : nurseStr,
		hospId:hospID,
		rows:99999
	},function(data){
		setDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',data); 
	})
};

// 查询病区分组列表
function searchGroup(){
	var code=$.trim($("#code").val());
	var name=$.trim($("#name").val());
	var activeFlag = $("#active").radio('getValue') ? "Y" : "N";
	var wardid=$("#ward").combogrid("getValue");
	reloadDataGrid(wardid,code,name,activeFlag)
}

// 新增/修改责组
function saveWardProGroup(flag){
	var rowid="";
	var rows = $('#groupGrid').datagrid("getSelections");
	var bedNums=0;
	if(flag){		
		if (rows.length == 1) {
			var rowid=rows[0].rowid;
			bedNums=rows[0].bedNums;
		}else{
			$.messager.alert("简单提示", "请选择要修改的分组", "info");
			return;
		}
	}
	var wardid=$("#ward").combogrid("getValue");
	var code=$.trim($("#code").val());
	var name=$.trim($("#name").val());
	var activeFlag = $("#active").radio('getValue') ? "Y" : "N";
	if(wardid == "")
	{
		$.messager.popover({ msg: '病区不能为空！', type:'error' });
    	return false;
	}
	if(code == "")
	{
		$.messager.popover({ msg: '责组代码不能为空！', type:'error' });
    	return false;
	}		
	if(name == "")
	{
		$.messager.popover({ msg: '责组名称不能为空！', type:'error' });
    	return false;
	}
	if(nurseStr == "")
	{
		$.messager.popover({ msg: '责组护士不能为空！', type:'error' });
    	return false;
	}
	if(!flag && (rows.length ==1) && (wardid==rows[0].wardid)){
		var nurseArr=nurseStr.split("@");
		var nurse="@"+rows[0].nurseId;
		nurse=nurse[nurse.length-1]!="@" ? nurse+"@" : nurse;
		var repeatFlag=false;
		nurseArr.forEach(function(val,index){
			var str="@"+val+"@";
			if(nurse.indexOf(str)>-1){
				repeatFlag=true;	
			}
		})
		if(repeatFlag)
		{
			$.messager.popover({ msg: '同病区同一护士不能分管多个责组！', type:'error' });
	    	return false;
		}
	}
	if(bedNums>0 && activeFlag!="Y"){
		$.messager.confirm("简单提示", "已分配床位，取消激活将释放床位，是否确认修改？", function (r) {
			if (r) {
				var delBeds=[];
				if(curGroupedBeds.length>0){
					curGroupedBeds.forEach(function(val,key){
						delBeds.push(val.rowid);
			      	})
				}
				saveGroup(rowid,code,name,activeFlag,wardid);
				saveBeds(rowid,name,[],delBeds,0);
			}
		});	
	}else{
		saveGroup(rowid,code,name,activeFlag,wardid);	
	}	
}

function saveGroup(rowid,code,name,activeFlag,wardid){
	$.m({
		ClassName:"Nur.NIS.Service.Base.GroupSettingV2",
		MethodName:"SaveWardProGroup",
		"rowid":rowid,
		"groupCode":code,
		"groupDesc":name,
		"activFlag":activeFlag,
		"wardDr":wardid,
		"updateUser":userID,
		"nurList":nurseStr,
		"hospId":hospID
	},function testget(result){
		if(result == "0"){
			$.messager.popover({msg:"保存成功！", type:'success'});		
			$('#form').form("load",{
		 		Rowid: "",
		 		Code: "",
		 		Name: "",
		 		Nurse: []	
	 		});
	 		nurseStr="";
	 		var wardid=$("#ward").combogrid("getValue");
	 		GetUngroupedMainNurses("",wardid,"");	
			reloadDataGrid(wardid,"","",activeFlag);
			getBedList("","",wardid);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 排序
function compare(propertyName){
    return function(a,b){
        var value1 = a[propertyName];
        var value2 = b[propertyName];
        return value1 - value2;
    }
}
// 根据床位数据
function getBedList(rowid,desc,wardid){
	allGroupedBeds=[];
	var html=""; 
	var html2="";
	if(rowid){
		$.m({
			ClassName:"Nur.NIS.Service.Base.GroupSettingV2",
			MethodName:"FindBedList",
			"wardID":wardid
		},function testget(result){	
			var result=JSON.parse(result);			
			curGroupedBeds=[];
			if(result["all"].length>0){
				var key=rowid+"^"+desc;
				var curGroupBed=[];
				var otherGroupBed=[];
				var str="<table>";
				var keyArr=[];
				for(var index in result){	
					if(index!="all"){
						if(index==key){
							curGroupedBeds=result[index];
							result[index].forEach(function(val,ind){
								curGroupBed.push(val.bedCode);
								allGroupedBeds.push(val);
							})
						}else{
							result[index].forEach(function(val,ind){
								otherGroupBed.push(val.bedCode);
								allGroupedBeds.push(val);
							})						
						}
						keyArr.push(index);
					}			
				}
				var groupedBed={
					"cur": curGroupBed,
					"other":otherGroupBed
				}
				// 管理组（包含所有床位）
				var allBeds=result["all"].sort(compare("bedCode"))
				allBeds.forEach(function(val,index){
					if(groupedBed["cur"].indexOf(val.bedCode)>-1){
						html+='<li class="cur grouped active" data-bedid="'+val.pacBedID+'">'+val.bedCode+'</li>';
					}else if(groupedBed["other"].indexOf(val.bedCode)>-1){
						html+='<li class="other grouped" data-bedid="'+val.pacBedID+'">'+val.bedCode+'</li>';
					}else{
						html+='<li data-bedid="'+val.pacBedID+'">'+val.bedCode+'</li>';
					}	
				})			
				
				// 已分组
				if(keyArr.length==0){
					html2+='<tr><td><div class="beds">'
					html2+='<p style="height:30px;line-height:30px;border-bottom:1px solid #ccc;text-align:center;">'+$g("全部患者")+'（'+result["all"].length+'）</p>';
					html2+='<p style="text-align:center; height:60px;line-height:60px;">'+$g("不分组")+'</p></td></tr>';
				}else{			
					for(var i=0;i<keyArr.length;i++){
						if(i%3==0){
							if(i!=0){
								html2+='</tr>';
							}
							html2+='<tr>';						
						}
						if(i>=3 && i+1==keyArr.length && ((i+1)%3==1 || (i+1)%3==2)){
							html2+='<td class="borderRight">'
						}else{
							html2+='<td>'
						}
						html2+='<div class="beds">';	
						html2+='<p style="height:30px;line-height:30px;border-bottom:1px solid #ccc;text-align:center;">'+keyArr[i].split("^")[1]+'（'+result[keyArr[i]].length+'）</p>';
						html2+='<ul>';
						var arr=result[keyArr[i]].sort(compare("bedCode"));
						arr.forEach(function(val,index){
							html2+="<li>"+val.bedCode+"</li>";	
						})
						html2+='</ul></div></td>';	
					}
					html2+="</tr>";
				}			
			}
			$(".edit-area .beds ul").html(html);  // 管理组（包含所有床位）
			$(".preview-area table").html(html2); // 已分组
		})
	}else{
		$(".edit-area .beds ul").html(html);  // 管理组（包含所有床位）
		$(".preview-area table").html(html2); // 已分组
	}	
}

// 保存当前责组已选中床位
function saveGroupBeds(){
	var rows=$("#groupGrid").datagrid("getSelections");
	var activeFlag = rows[0].active;
	if(activeFlag=="Y"){
		var selectedBeds=[];
		var selectedBedCode=[];
		// 已选中床位
		var elements=$(".edit-area .beds li.active")
		if(elements.length > 0){
			elements.each(function(index,ele){
				var bedID=$(this).data("bedid");
				var bedCode=$(this).html();
				selectedBeds.push(bedID);
				selectedBedCode.push(bedCode);
			})	
		}
		// 其他组已保存床位
		var otherGroupedBedCode=[];
		var elements2=$(".edit-area .beds li.other")
		if(elements2.length > 0){
			elements2.each(function(index,ele){
				var bedCode=$(this).html();
				otherGroupedBedCode.push(bedCode);
			})	
		}
		// 当前组删除的已保存的床位
		var delBeds=[];
		var delBedCode=[];
		if(curGroupedBeds.length>0){
			curGroupedBeds.forEach(function(val,key){
				var index=selectedBeds.indexOf(val.pacBedID);
	        	if (index == -1) {
		        	delBeds.push(val.rowid);
		        	delBedCode.push(val.bedCode);
	        	}
	      	})
		}
		// 当前组选中的其他组已保存的床位
		var selectedOtherBedCode=[];
		if(selectedBedCode.length>0 && otherGroupedBedCode.length > 0){
			selectedBedCode.forEach(function(val,index){
				if(otherGroupedBedCode.indexOf(val)>-1){
					selectedOtherBedCode.push(val);
				}	
			})
		}
		// 要调整的床位
		var newArr=selectedOtherBedCode.concat(delBedCode);
		var rowID=$.trim($("#rowid").val());
		var desc=$.trim($("#name").val());
		if(delBeds.length > 0 || (delBeds.length==0 && selectedBeds.length!=curGroupedBeds.length)){
			var str="";
			str=newArr.sort().join("、");
			if(str!=""){			
				var msg=str+"床已分组，是否确认调整？";
				$.messager.confirm("简单提示", msg, function (r) {
					if (r) {
						saveBeds(rowID,desc,selectedBeds,delBeds,0);
					}
				});				
			}else{
				saveBeds(rowID,desc,selectedBeds,delBeds,0);
			}		
		}
	}else{
		$.messager.popover({ msg: "该责组未激活！", type:'error' });		
	}	
}

// 不分组
function resetBeds(){
	var rowID=$.trim($("#rowid").val());
	var desc=$.trim($("#name").val());
	var selectedBeds=[];
	var delBeds=[];
	var delBedCode=[];
	if(allGroupedBeds.length > 0){
		allGroupedBeds.forEach(function(val,index){
			delBeds.push(val.rowid);
			delBedCode.push(val.bedCode);
		})		
		var str=delBedCode.sort().join("、");					
		var msg=str+"床已分组，是否确认调整？";
		$.messager.confirm("简单提示", msg, function (r) {
			if (r) {
				saveBeds(rowID,desc,selectedBeds,delBeds,1);
			}
		});					
	}
}

function saveBeds(rowID,desc,selectedBeds,delBeds,flag){
	$.m({
		ClassName:"Nur.NIS.Service.Base.GroupSetting",	
		MethodName:"SaveWardProGroupBed2",
		groupID:rowID,
		addPacBeds:JSON.stringify(selectedBeds),
		delBedIDs:JSON.stringify(delBeds),
		updateUser:userID
	},function testget(result){
		if(result == "0"){
			$.messager.popover({msg:"保存成功！", type:'success'});			
			var activeFlag = $("#active").radio('getValue') ? "Y" : "N";
			var wardid=$("#ward").combogrid("getValue");
			if(!flag){
				reloadDataGrid(wardid,"","",activeFlag,1);
				//var nums=$(".edit-area .beds li.active").length;
				//$(".datagrid-row-selected td:nth-child(5) .datagrid-cell").html(nums);
				
//				$('#form').form("load",{
//			 		Rowid: rowID	
//		 		});
//		 		$("#groupGrid").datagrid("selectRecord",rowid);
			}else{
				// 不分组
				$(".datagrid-row td:nth-child(5) .datagrid-cell").html(0);
			}			
			getBedList(rowID,desc,wardid);			
		}else{
			$.messager.popover({ msg: result, type:'error' });		
		}
	})
}

function getSwitchFlag(){
	switchFlag=$.m({
		ClassName:"Nur.NIS.Service.Base.GroupSettingV2",
		MethodName:"GetSwitchFlag",
		hospID:hospID
	},false)
	// 护理分组权限
    var flag=switchFlag == "Y" ? true : false;
    $HUI.switchbox("#switch").setValue(flag);
}

// 改变窗口大小，重新渲染页面
function resizeFresh(){
	location.reload();
}