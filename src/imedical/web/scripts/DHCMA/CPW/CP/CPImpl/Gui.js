var obj = new Object();	
function InitCPImplWin(){
    $.parser.parse(); // 解析整个页面  
    var DivWidth=$("#CPW-main").width();
	obj.PathwayID="";
	obj.MrListID="";
	obj.ARStatus=0;
	obj.StepSelecedID="";
	obj.PCSDStatus="";	
	obj.flag=0;
	obj.Times=""
	if ((CPWStatus=="T")||(CPWStatus=="")){
		if (typeof HISUIStyleCode === 'undefined'){
			$("#nocpw").attr("src","../scripts/DHCMA/img/blue.png")
			$("#nocpw").attr("style","position:relative;top:50%;margin-top:-150px;")
		}else{
			if (HISUIStyleCode=="lite"){
				$("#imgTitle").attr("style","position:fixed;top:29%;left:43%;z-index:99")
				$("#nocpw").attr("src","../scripts/DHCMA/img/lite.png")
				$("#nocpw").attr("style","position:relative;top:40%;margin-top:-200px;")
			}else{
				$("#nocpw").attr("src","../scripts/DHCMA/img/blue.png")
				$("#nocpw").attr("style","position:relative;top:50%;margin-top:-150px;")
			}
		}
	}
	
	//主要诊疗工作
	obj.gridTreatment = $HUI.datagrid("#tb-Treatment",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		sortName:"IndexNo",
		sortOrder:"asc",
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID+"||"+obj.StepSelecedID,
			aType:"T" 
	    },
		columns:[[
			{field:'Operation',title:'操作',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<span style=\"cursor:pointer\" class=\"Operimg img-TOper icon-add" onclick=\"obj.ExecuteItem(\'' + RowID+ '\')\" title='+$g("执行")+'>&nbsp;&nbsp;&nbsp;&nbsp;</span>'
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<span style=\"cursor:pointer\" class=\"Operimg img-TOper icon-no" onclick=\"obj.CancelItem(\'' + RowID+ '\')\" title='+$g("撤销")+'>&nbsp;&nbsp;&nbsp;&nbsp;</span>'
					}
					return retStr;
				}
			},
			{field:'IndexNo',title:'序号',align:'center',width:DivWidth*0.07},
			{field:'ItemInfo',title:'项目内容',width:DivWidth*0.85,
				formatter: function(value,row,index){
					return value+'<div title='+$g("备注")+' style="border:none;float:right;width:20px;height:20px;cursor:pointer;" id=Treat'+row.ID+' class=\"icon icon-other-yellow" onclick=\"obj.TreatNode(\'' + row.ID+'\',\''+index +'\',\''+row.Node+'\')\"></div>'
				}
			},
			{field:'IsRequired',title:'是否必选',align:'center',width:DivWidth*0.08,
				formatter: function(value,row,index){
					var retStr = $g("否");
					if (value==1) {
						retStr =$g("是")
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'执行信息',width:DivWidth*0.3}	
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
			
            return true;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridTreatment_onSelect();	
			}
		},
		onLoadSuccess: function(data) {
			obj.OperationControl();
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	//主要护理工作
	obj.gridNursing = $HUI.datagrid("#tb-Nursing",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		sortName:"IndexNo",
		sortOrder:"asc",
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: "", 	
			aEpisID: "", 
			aType:"N" 
	    },
		columns:[[
			{field:'Operation',title:'操作',align:'center',width:DivWidth*0.05,
				formatter: function(value,row,index){
					var retStr = "";
					var RowID=row["ID"];
					if (value.split("^")[0]==1) {
						retStr = retStr + '<span id="NOper" style=\"cursor:pointer\" class=\"Operimg img-NOper icon-add" onclick=\"obj.ExecuteItem(\'' + RowID+ '\')\" title="执行">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
					}
					if (value.split("^")[1]==1) {
						retStr = retStr + '<span id="NOper" style=\"cursor:pointer\" class=\"Operimg img-NOper icon-no" onclick=\"obj.CancelItem(\'' + RowID+ '\')\" title="撤销">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
					}
					return retStr;
				}
			},
			{field:'IndexNo',title:'序号',align:'center',width:DivWidth*0.07},
			{field:'ItemInfo',title:'项目内容',width:DivWidth*0.85,
				formatter: function(value,row,index){
					return value+'<div title="显示备注" style="border:none;float:right;width:20px;height:20px;cursor:pointer;" id=Nur'+row.ID+' class=\"icon icon-other-yellow" onclick=\"obj.NurNode(\'' + row.ID+'\',\''+index +'\',\''+row.Node+'\')\"></div>'
				}
			},
			{field:'IsRequired',title:'是否必选',align:'center',width:DivWidth*0.08,
				formatter: function(value,row,index){
					var retStr = $g("否");
					if (value==1) {
						retStr =$g("是")
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'执行信息',width:DivWidth*0.3}	
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridNursing_onSelect();	
			}
		},
		onLoadSuccess: function(data) {
			obj.OperationControl();
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	
	//路径病人
	if(UserType=="N"){
		obj.gridAdm = $HUI.datagrid("#gridAdm",{
			fit: true,
			title: "路径病人",
			iconCls:"icon-resort",
			headerCls:'panel-header-gray',
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			//rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			autoRowHeight: false, 
			loadMsg:'数据加载中...',
			pageSize: 10,
			pageList : [10,20,50,100],
		    url:$URL,
		    idField:'EpisodeID',
		    nowrap:false,
			queryParams:{
			    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
				QueryName:"QryAdmByWard",		
				aWard:session['LOGON.WARDID'],
			},
			columns:[[
				{field:'PatName',title:'姓名',align:'center',width:'80'},
				{field:'Bed',title:'床号',align:'center',width:'50'},
				{field:'Flag',title:'签名',align:'center',width:'80',
					formatter: function( v, r, i){
						if (v == "1") return $g("待签名");
						else if (v == "2") return $g("需签名");
						else return $g("已签名");
					},
					styler: function(value,row,index){
						if (value== "1") {
							return "background-color:#FFFAE8;color:#FFA200"
						}
				}},
				{field:'Nurse',title:'护理',align:'center',width:'80',
					formatter: function(v, r, i){
						if (v == "1") return $g("已执行");
						else return $g("待执行");
					},
					styler: function(value,row,index){
						if (value != "1") {
							return "background-color:#FFEDEB;color:#FF1414"
						}
				}},
			]],
			onSelect:function(rindex,rowData){
				if (rindex>-1) {
					obj.gridAdm_onSelect();
				}
			},
			onLoadSuccess:function(data){
				var rowData = data.rows;
	            $.each(rowData,function(idx,val){//遍历JSON
	                  if((val.EpisodeID==EpisodeID)&&(obj.flag==0)){
	                    $('#gridAdm').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
	                    obj.flag=1
	                  }
	            });
			}
		})
	}
	//重点医嘱
	obj.gridOrder = $HUI.datagrid("#tb-Order",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		//pageSize: 20,
		//pageList : [20,50,100,200],
		sortName:"IndexNo",
		sortOrder:"asc",
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: "", 	
			aEpisID: "", 
			aType:"O" 
	    },
		columns:[[
			{field:'IndexNo',title:'序号',align:'center',width:DivWidth*0.07},
			{field:'ItemInfo',title:'项目内容',width:DivWidth*0.85},
			{field:'IsRequired',title:'是否必选',align:'center',width:DivWidth*0.08,
				formatter: function(value,row,index){
					var retStr = $g("否");
					if (value==1) {
						//retStr = retStr + '<img title="必须执行" style="margin:0 25px;border-radius:50%" src="../scripts/DHCMA/img/ok.png"></img>';
						retStr = $g("是")
					}
					return retStr;
				}
			}, 
			{field:'OperInfo',title:'执行信息',width:DivWidth*0.3}	
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		rowStyler: function(index,row){
			if (parseInt(row["IsImp"])>0){
				return 'color:#509DE1;'; 
			}else{
				return 'color:#000000;'; 
			}
		}
	});
	//路径外医嘱
	obj.gridVarOrder = $HUI.datagrid("#tb-Variation-Order",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWVarOrder",		
			aPathwayID: "", 
			aEpisID:"",
			page:1,
			rows:9999
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'序号',align:'center',width:''},
			{field:'ARCIMDesc',title:'医嘱描述',width:'300'},
			{field:'VariatCat',title:'变异原因',width:'200'},
			{field:'VariatTxt',title:'具体原因',width:'200',editor:'text'}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		}
		,onCheck:function(rindex,rowData){			
			if (rindex>-1) {
				$('#tb-Variation-Order').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){			
			$('#tb-Variation-Order').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
			var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
			$(ed.target).focus();
		}
	});
	
	//未执行项目
	obj.gridVarItem = $HUI.datagrid("#tb-Variation-Item",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		//pageSize: 20,
		//pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWVarItem",		
			aPathwayID: "", 	
			aEpisID: "",
			aUserType:UserType,
			aHospID:session['DHCMA.HOSPID'],
			page:1,
			rows:9999
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'ind',title:'序号',align:'center',width:''},
			{field:'TypeDesc',title:'分类',width:''},
			{field:'ItemDesc',title:'内容',width:'400'},
			{field:'VariatCat',title:'变异原因',width:'200'},
			{field:'VariatTxt',title:'具体原因',width:'200',editor:'text'}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		}
		,onCheck:function(rindex,rowData){			
			if (rindex>-1) {
				$('#tb-Variation-Item').datagrid("beginEdit", rindex);
				var ed = $(this).datagrid('getEditor', {index:rindex,field:'VariatTxt'});
				$(ed.target).focus();
			}
			
		},
		onClickRow: function(rowIndex,rowData){			
			$('#tb-Variation-Item').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
			var ed = $(this).datagrid('getEditor', {index:rowIndex,field:'VariatTxt'});
			$(ed.target).focus();
		}
	});
	
	obj.OutReason = $HUI.combobox('#OutReason', {
		url: $URL,
		editable: false,
		placeholder:'请选择',
		valueField: 'VarID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVariatSrv';
			param.QueryName = 'QryVerByTypeCat';
			param.aTypeCode = '02';
			param.aCatCode = '';
			param.ResultSetType = 'array';
		},
	});
	obj.UCanReason = $HUI.combobox('#UCanReason', {
		url: $URL,
		editable: false,
		placeholder:'请选择',
		valueField: 'VarID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVariatSrv';
			param.QueryName = 'QryVerByTypeCat';
			param.aTypeCode = '04';
			param.aCatCode = '';
			param.ResultSetType = 'array';
		},
	});
	
	obj.serchType="myloc";
	obj.searchValue=""
	$("#CPWLocType").keywords({
	    singleSelect:true,
	    labelCls:'blue',
	    items:[
	        {text:$g('关联路径'),id:'myloc',selected:true},
	        {text:$g('所有路径'),id:'othloc'}
	    ],
	    onClick:function(v){
		    obj.serchType=v.id;
			obj.SearchCPW();
		}
	});
	$('#CPWSearch').searchbox({ 
		searcher:function(value){
			obj.searchValue=value;
			obj.SearchCPW();
		}
	}); 
	
	//出院患者入径按钮不可用
	if (DischInfo.split("^")[0]=="D"){
		  $("#btn-GetInCPW").linkbutton('disable');
	}
	if(IsOpenUCancel=="0"){
		$('#btnUCancel').css('display','none');
	}
	InitCPImplWinEvent(obj);
	obj.LoadEvent(arguments);
	
	//付费病种图标信息提醒
	if(parseInt(IsOpenPCSDMod)==1){
		var script=document.createElement('script');
		script.type = 'text/javascript';
		script.src = '../scripts/DHCMA/CPW/SD/PCIO/ToCPW.js';
		document.getElementsByTagName('head')[0].appendChild(script);
			
		setTimeout(function(){
			ShowSDPCInfo(obj);
		},1000)
	}
	
	return obj;
}


