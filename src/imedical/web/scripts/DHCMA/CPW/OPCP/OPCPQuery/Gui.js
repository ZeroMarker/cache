//页面Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    obj.Status="";
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    //obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"CPW");
    var aHospID = session['LOGON.HOSPID']+"!!1";
    obj.cboSSHosp = Common_ComboToSSHosp2("cboSSHosp",aHospID,"");
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["OID"].split("!!")[0];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","O",HospID);
	    }
    });
	
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));// 日期初始赋值
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));
	var cboStatus = $HUI.combobox("#cboStatus",{
		valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
		data:[
			{id:'I',text:'入径'}
			,{id:'C',text:'完成'}
			,{id:'O',text:'出径'}
		],
		formatter:function(row){  
			var opts;
			if(row.selected==true){
				opts = "<input type='checkbox' checked='checked' id='r"+row.id+"' value='"+row.id+"' style='vertical-align:middle;margin-right: 3px;'>"+row.text;
			}else{
				opts = "<input type='checkbox' id='r"+row.id+"' value='"+row.id+"' style='vertical-align:middle;margin-right: 3px;'>"+row.text;
			}
			return opts;
		},
		onSelect:function(rec) {
			var objr =  document.getElementById("r"+rec.id);
			$(objr).prop('checked',true);
			obj.Status=obj.Status+"^"+rec.id;
		}
		,onUnselect:function(rec){
			var objr =  document.getElementById("r"+rec.id);
			$(objr).prop('checked',false);
			var subStr="^"+rec.id;
			obj.Status=obj.Status.replace(subStr,"");
		}
	});
	
   obj.GridCheckQuery = $HUI.datagrid("#GridCheckQuery",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//url:$URL,
		columns:[[
			{field:'PapmiNo',title:'登记号',width:'100'},
			{field:'PatName',title:'患者姓名',width:'80'},
			{field:'PatSex',title:'性别',width:'50'},
			{field:'PatAge',title:'年龄',width:'50'},
			{field:'CPWDesc',title:'路径名称',width:'250'}, 
			{field:'CPWStatus',title:'路径状态',width:'50',
				 styler: function(value,row,index){
					if ((typeof HISUIStyleCode === 'undefined') || (HISUIStyleCode=="blue")){
						if (value=="入径") {
							retStr =  'color:blue;';
						} else if (value=="完成") {
							retStr = 'color:green;';
						}else if (value=="出径") {
							retStr = 'color:red;';
						} else {
							retStr = 'color:black;';
						} 
						return retStr;
					}
					
				}
			},  
			//{field:'PatCost',title:'总费用',width:'100'}, 
			{field:'InUserDesc',title:'入径人',width:'80'},
			{field:'InLocDesc',title:'入径科室',width:'100'}, 
			{field:'InDate',title:'入径日期',width:'100'}, 
			{field:'OutDate',title:'出径日期',width:'100'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				//alert(rowData['PatientID']+","+rowData['CPWID']);
				obj.GetPathwayVisit(rowData);
			}
		},
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onLoadSuccess:function(data){
			if (typeof HISUIStyleCode !== 'undefined'){
				if (HISUIStyleCode=="lite"){
					$("#center .hisui-panel").attr("style","border-color:#E2E2E2;border-top:0;border-radius:0 0 4px 4px;")
				}
			}
		}
	});
	obj.GetPathwayVisit = $HUI.datagrid("#PathVisitByaEpisodeID",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//url:$URL,
		columns:[[
			{field:'aEpisodeID',title:'就诊ID',width:'80'},
			{field:'PatName',title:'患者姓名',width:'80'},
			{field:'CPWDesc',title:'路径名称',width:'230'}, 
			{field:'DiagnoseC',title:'中医诊断',width:'150'	}, 
			{field:'DiagnoseF',title:'西医诊断',width:'150'}, 
			{field:'CPWStatus',title:'状态',width:'80',
				 styler: function(value,row,index){
					 if ((HISUIStyleCode=="blue")||(typeof HISUIStyleCode === 'undefined')){
						if (value=="就诊入径") {
							retStr =  'color:blue;';
						}else if(value="未入径"){
							retStr = 'color:red'
						}else {
							retStr = 'color:black;';
						} 
						return retStr;
					 }
				}
			}, 
			//{field:'PatCost',title:'总费用',width:'80'}, 
			{field:'EpisDesc',title:'入径阶段',width:'80'},
			{field:'InUserDesc',title:'入径人',width:'80'},
			{field:'InLocDesc',title:'入径科室',width:'150'}, 
			{field:'InDate',title:'就诊入径日期',width:'100'},
			{field:'InTime',title:'就诊入径时间',width:'100'}
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
		onLoadSuccess:function(data){
			if (typeof HISUIStyleCode !== 'undefined'){
				if (HISUIStyleCode=="lite"){
					$("#winPathVisit .hisui-panel").attr("style","border-color:#E2E2E2;border-radius:4px;")
				}
			}
		}
	});
	obj.GridPathVisit = $HUI.datagrid("#GridPathVisit",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//url:$URL,
		columns:[[
			{field:'aEpisodeID',title:'就诊ID',width:'80'},
			{field:'PatName',title:'患者姓名',width:'80'},
			{field:'PatSex',title:'性别',width:'50'},
			{field:'PatAge',title:'年龄',width:'50'},
			{field:'CPWDesc',title:'路径名称',width:'230'}, 
			{field:'DiagnoseC',title:'中医诊断',width:'100'	}, 
			{field:'DiagnoseF',title:'西医诊断',width:'100'}, 
			{field:'CPWStatus',title:'状态',width:'80',
				 styler: function(value,row,index){
					 if ((HISUIStyleCode=="blue")||(typeof HISUIStyleCode === 'undefined')){
						if (value=="就诊入径") {
							retStr =  'color:blue;';
						} else if(value="未入径"){
							retStr = 'color:red'
						}else {
							retStr = 'color:black;';
						}  
						return retStr;
					 }
				}
			}, 
			//{field:'PatCost',title:'总费用',width:'80'},
			{field:'EpisDesc',title:'入径阶段',width:'80'}, 
			{field:'InUserDesc',title:'入径人',width:'80'},
			{field:'InLocDesc',title:'入径科室',width:'100'}, 
			{field:'InDate',title:'就诊入径日期',width:'100'},
			{field:'InTime',title:'就诊入径时间',width:'100'}
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
		onLoadSuccess:function(data){
			if (typeof HISUIStyleCode !== 'undefined'){
				if (HISUIStyleCode=="lite"){
					$("#winGridPathVisit .hisui-panel").attr("style","border-color:#E2E2E2;border-radius:4px;")
				}
			}
		}
	});
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}
