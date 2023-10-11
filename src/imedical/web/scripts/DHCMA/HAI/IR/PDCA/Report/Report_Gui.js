var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var obj = new Object();
function InitPARepWin() {
	obj.RepID=ReportID;		//报告ID
	obj.RegID=RegTypeID;	//模板ID
	obj.Admin=AdminPower;	//'管理员'标记(院感科)
	obj.GroupDesc = session['LOGON.GROUPDESC'];
	obj.IsPDCASign = $m({	//启用'护士长/科主任'
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "IsPDCASign"
	}, false);
	obj.SupNurFlg =0;		//'护士长'标记
	if(obj.GroupDesc.indexOf('护士长')>-1)obj.SupNurFlg=0;	
    obj.SupDocFlg =0;		//'科主任'标记	
	if(obj.GroupDesc.indexOf('主任')>-1)obj.SupDocFlg=0;	
	obj.RepStatusCode="";	//报告状态
	
	//'文件框'公共JS
    InitPARepWinUpLoad(obj);
    //'富文本'公共JS
    InitPARepWinEditor(obj);	
    //'科室'公共JS
    InitPARepWinLoc(obj);
    
	//一、基本信息
	//1.1.初始化'项目类型'
	$("#cboItemType").lookup({
		panelWidth:220,
		url:$URL,
		editable: true,
		mode:'remote',
		valueField: 'ID',
		textField: 'ItemType',
		queryParams:{
			ClassName: 'DHCHAI.IRS.PDCARepSrv',
			QueryName: 'QryPAItemType'
		},
		columns:[[  
			{field:'ID',title:'ID',width:50},
			{field:'ItemType',title:'类型',width:150}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q']; 
			param = $.extend(param,{aItemType:desc}); 	//将参数q转换为类中的参数
		},
		pagination:true,
		showPageList:false, showRefresh:false,displayMsg:'',
		loadMsg:'正在查询',
		isCombo:true,            		 				//是否输入字符即触发事件，进行搜索
		minQueryLen:1             						//isCombo为true时，可以搜索要求的字符最小长度
	});
	//1.2.初始化'指标名称'
	var IndexList = $cm ({
		ClassName:"DHCHAI.IRS.PDCAIndexBaseSrv",
		QueryName:"QryPDCAIndexBase",
		aIsActive:1
	},false);
	$HUI.combobox("#cboIndex",{
		valueField:'ID',
		textField:'IndexDesc',
		editable:false,
		data:IndexList.rows
	});
	//二、扩展信息(默认模板'问题聚焦'+'现状分析')
	//2.1.定义显示数组(默认2~10)
    obj.NumID=2;
    obj.NumList = new Array();
	obj.NumList[2]="二",obj.NumList[3]="三",obj.NumList[4]="四",obj.NumList[5]="五",obj.NumList[6]="六";
	obj.NumList[7]="七",obj.NumList[8]="八",obj.NumList[9]="九",obj.NumList[10]="十",obj.NumList[11]="十一"; 
	//2.2.文件框ID
	obj.FileID=1;
    obj.FileList = new Array();
	//2.3.编辑框ID
	obj.EditID=1;
    obj.EditList = new Array();
	//2.4.根据'模板'构造'扩展内容'
	var ExtList= $cm ({
		ClassName:"DHCHAI.IRS.PDCAModSrv",
		QueryName:"QryPDCAExpType",
		aRegID:obj.RegID
	},false);
	var Html="";
    for (var xInd = 0; xInd < ExtList.total; xInd++) {
        var ExtInfo = ExtList.rows[xInd];
        
		var TypeID 		= ExtInfo.DicID;		//ID(1068)
        var TypeCode 	= ExtInfo.DicCode;		//Code(1)
        var TypeDesc	= ExtInfo.DicDesc;		//Desc(问题聚焦)
        
        //构建DIV(问题聚焦)
        Html= Html+"<div style='padding:5px 0px 5px 0px;'class='hisui-panel' data-options=\"title:'" +obj.NumList[obj.NumID]+"、"+TypeDesc+ "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\">";
		var DataList= $cm ({
			ClassName:"DHCHAI.IRS.PDCAModSrv",
			QueryName:"QryPDCAExpTypeExt",
			aRegID:obj.RegID,
			aTypeID:TypeID
		},false);
		for (var yInd = 0; yInd < DataList.total; yInd++) {
        	var DataInfo = DataList.rows[yInd];
        
			var ID 		= DataInfo.ID;		//ID(1||7)
        	var Code 	= DataInfo.Code;	//Code(010200)
        	var Desc	= DataInfo.Desc;	//Desc(问题聚焦-描述)
        	//多语言处理
        	Desc=$g(Desc);
			//构建'条目'(问题聚焦-描述)
			var DataType= DataInfo.DatCode; 
			if (DataType == "F") { 			//文件
				Html= Html+'<div style="padding-left:10px;">'
					+'	<div class="UpLoad"><input class="" type="file" id="'+Code+'" name="uploadify"/><span id="'+Code+'_arg"></span></div>'
					+'</div>';
				//存储ID
				obj.FileList[obj.FileID]=Code;
				obj.FileID++;
			}
			if (DataType == "ED") { 		//编辑框
				Html= Html+'<div style="clear:both;"></div>';	//清除浮动
				Html= Html+'<div">'
					+'	<script type="text/plain" id="'+Code+'" style="border:1px solid #d4d4d4;"></script>'
					+'</div>';
				//存储ID
				obj.EditList[obj.EditID]=Code;
				obj.EditID++;
			}
			if (DataType == "DD") { 		//日期
				Html= Html+'<div style="float:left;width:25%;">'
					+'	<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;">' + Desc + ':</span>'
					+'	<input class=\'hisui-datebox textbox\' id="' + Code + '"style="width:167px;"/>'
					+'</div>'; 
			}	
		}	
		Html= Html+"</div>";
	    obj.NumID++;
    }
	$('#ExtDiv').html(Html);
    $.parser.parse('#ExtDiv'); 			// 解析
	//2.5.初始化'文件框'
    for(ind=1;ind<=obj.FileList.length;ind++){
		var ID=obj.FileList[ind];
		obj.LoadUpLoad(ID);
	}
    //2.6.初始化'编辑框'
    for(ind=1;ind<=obj.EditList.length;ind++){
		var ID=obj.EditList[ind];
		obj.LoadEditor(ID,"1260","150");
	}
    //2.7.调整编辑框边距
	$('#ExtDiv .edui-container').css('padding','5px 10px 5px 10px');
    //三、Plan-整改科室(计划)
    //3.1.获取科室列表
    obj.LocList = $cm({
		ClassName: "DHCHAI.IRS.PDCARepSrv",
		QueryName: "QryPARepLoc",
		aRepID: obj.RepID,
		aIsHist:"0",
		rows: 999
	}, false);
    //3.2.添加Panel
	var Html="<div style='padding:5px 0px 5px 0px;'class='hisui-panel' data-options=\"title:'" +obj.NumList[obj.NumID]+"、P(计划与目标)"+ "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\">"
			+"	<div id='PlanLocDiv'></div>"
			+"	<div id='PlanAddDiv' style='padding-left:10px;'>"
			+" 		<a href='#' id='btnAddPlanLoc' style='display:inline-block;width:1260px;line-height:50px;text-align:center;'>✚</a>"
			+"	</div>"
			+"</div>";
	obj.NumID++;	
	$('#PlanDiv').html(Html);
    $.parser.parse('#PlanDiv'); 			// 解析	
   	3.3.初始化Plan
   	$('#PlanLocDiv').html("");	
    if(obj.RepID==""){
		obj.AddPlanHtml(1);
		//默认一条数据
		obj.LocIndexList[obj.LocIndexID]=obj.IndexVal;
		obj.LocSubList[obj.LocIndexID]="";
		obj.LocIndexID++;
		obj.IndexVal++;
	}
	else{
		for(ind=0;ind<obj.LocList.total;ind++){
			var LocInfo = obj.LocList.rows[ind];
        	var Index=LocInfo.Index;
			
			obj.AddPlanHtml(Index);
			//存储数据
			obj.LocIndexList[obj.LocIndexID]=Index;
			obj.LocSubList[obj.LocIndexID]=LocInfo.ID;
			obj.LocIndexID++;
			if(Index>obj.IndexVal)obj.IndexVal=Index;
		}
	}
	//四、Do-整改科室(执行)[Tab-多个整改科室]
	//4.1.初始化Do
	obj.LoadDoHtml();
	//五、C+A-整改科室(检查评价)
	//5.1.初始化C+A
	obj.LoadCAHtml();
	
    InitPARepWinEvent(obj);
    InitPARepWinChart(obj);
    InitFloatWin();				//加载帮助页面
    
    obj.LoadEvent();
    return obj;
}
