//页面Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    obj.Status="";
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp2("cboSSHosp",session['DHCMA.HOSPID'],"");
	
    //科室
	obj.cboLoc = $HUI.combobox("#cboLoc",{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.aAdmType="I",
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4,
		onLoadSuccess:function(data){
			//权限控制
			if(tDHCMedMenuOper['admin']<1){
				$("#cboLoc").combobox('select',session['DHCMA.CTLOCID']);	 
				$('#cboSSHosp').combobox('disable');
				$('#cboLoc').combobox('disable');
			} 	
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
		/*url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.PathwaySrv",
			QueryName:"QryCPWByDate",	
			aDateType: Common_GetValue('cboDateType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: obj.Status,
			aLocID:Common_GetValue('cboLoc'),
			aWardID:"",
			aHospID:Common_GetValue('cboSSHosp')
	    },*/
		columns:[[
			{field:'PapmiNo',title:'登记号',width:'100'},
			{field:'MrNo',title:'病案号',width:'100'},
			{field:'PatName',title:'患者姓名',width:'80'},
			{field:'PatSex',title:'性别',width:'50'},
			{field:'PatAge',title:'年龄',width:'50'},
			{field:'AdmDate',title:'入院日期',width:'100'},
			{field:'DischDate',title:'出院日期',width:'100'}, 
			{field:'CPWDesc',title:'路径名称',width:'250'}, 
			{field:'CPWStatus',title:'状态',width:'50',
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
			{field:'ExecReasonList',title:'路径切换原因',width:'200',formatter:function(v,r,i){
				var ReasonArr=v.split("^");
				if (ReasonArr.length>0){
					value=ReasonArr[ReasonArr.length-1]				//返回最新一次的路径切换原因
				}
				return value;
			}}, 
			//{field:'DiagnoseC',title:'中医诊断',width:'260'	}, 
			//{field:'DiagnoseF',title:'西医诊断',width:'260'}, 
			{field:'InHospDate',title:'住院天数',width:'80'}, 
			{field:'PatCost',title:'总费用',width:'100'}, 
			{field:'InUserDesc',title:'入径人',width:'80'},
			{field:'InLocDesc',title:'入径科室',width:'100'}, 
			{field:'InDate',title:'入径日期',width:'100'}, 
			{field:'OutDate',title:'出径日期',width:'100'},
			{field:'CPWID',title:'住院病历',width:'150',align:'center',sortable:true,
				formatter: function(value,row,index){
						var paadm=row.aEpisodeID.split('!!')[0];
						var patientID=row.PatientID;
						return '<a href="#" onclick=DisplayEPRView('+paadm+","+patientID+')>病历浏览</a>';
				}			
			
			}
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
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.GridCheckQuery_onDblClick(rowIndex,rowData);
			}
		},
		onLoadSuccess:function(data){
			if (typeof HISUIStyleCode !== 'undefined'){
				if (HISUIStyleCode=="lite"){
					$("#center .hisui-panel").attr("style","border-color:#E2E2E2;border-top:0;border-radius:0 0 4px 4px;")
				}
			}
		}
	});
	DisplayEPRView = function(EpisodeID,PatientID){
				var strUrl = cspUrl+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&2=2";
					 websys_showModal({
						url:strUrl,
						title:'浏览病历',
						iconCls:'icon-w-edit',  
						//onBeforeClose:function(){alert('close')},
						//dataRow:{ParamRow:obj.ItemRowData},   //？
						originWindow:window,
						width:1300,
						height:600
					});
	};
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


