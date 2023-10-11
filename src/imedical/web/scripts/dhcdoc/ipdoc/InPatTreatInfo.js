var opl=ipdoc.lib.ns("ipdoc.pattreatinfo");
opl.view=(function(){
	var PopoverList;
	function InitPatAdmInfoJson(){
		InitPatAdmInfo();
		PopoverList="#TendOrd,#Diet,#Drainage,#OrderKind,#TPRData,#BloodPressure,#Temperature,#Pulse,#Exam,#Lab,#CVReport,#EkgOrd,#DocCureApp";
		setTimeout(function(){
			///懒加载
			execScript("/imedical/web/scripts_lib/echarts3.6.2/echarts.min.js");
		});
		$("#AddEMRRecord").click(AddEMRRecordClickHandle);
	}
	function AddEMRRecordClickHandle(){
		if (typeof parent.switchTabByEMR =="function"){
			parent.switchTabByEMR($g("病程记录")); //dhc_side_emr_cate4
		}
	}
	/// 初始化界面的显示信息
	function InitPatAdmInfo(){
		$('#PatTreat-div').showMask();
		$.cm({
			ClassName:'web.DHCDocInPatPortalCommon',
			MethodName:'GetAdmInfoJson',
			EpisodeID:ServerObj.EpisodeID,
			UserCode:session['LOGON.USERCODE']
		},function(PatAdmInfoJson){
			var id,value,valueArr,text,color;
			var old=document.getElementById('PatTreat-div');
			var clone=old.cloneNode(true);
			for (var i=0;i<PatAdmInfoJson.length;i++){
				id=PatAdmInfoJson[i].id;
				value=PatAdmInfoJson[i].Value+"";
				var _$id=$(clone).find("#"+id+"");
				if (_$id.length>0){
					//$(clone).find("#"+id+"")[0].text=value;
					_$id.html(value);
				}
			}
			old.parentNode.replaceChild(clone,old)
			$('#PatTreat-div').hideMask();
			setTimeout(function(){
				InitPannelEvent();
			},1000);
			$("#AddEMRRecord").click(AddEMRRecordClickHandle);
		});
	}
	//初始化页面浮动
	function InitPannelEvent(){
		$(PopoverList).each(function(){
			var that=$(this);
			if (that.length==0){
				return true;
			}
			var ID=that.attr('id');
			that.parent().on({
				mouseenter:function(){
					if (LoadPopover("Load",that.attr('id'))){
						//浮动内容
						var HTML=GetPannelHTML(that.attr('id'));
						if (HTML.innerHTML==""){return;}
						that.popover({
							width:HTML.width,
							height:HTML.height,
							title:HTML.Title,
							content:HTML.innerHTML,
							trigger:'hover',
							placement:'auto',
							onShow:function(){
								if (LoadPopover("Show",that.attr('id'))){
									if (typeof HTML.CallFunction == "function"){
										setTimeout(function(){HTML.CallFunction.call();},50);
									}
								}
							}
						}).popover('show');
					}
				}
			});
		});
		
		
		/*
		$('#PatInfoTopLayOut').layout("panel","center").panel({    
			tools: [{    
				iconCls:'icon-add',    
				handler:function(){
					if (typeof parent.switchTabByEMR =="function"){
						parent.switchTabByEMR("dhc_side_oe_nurseepr");
					}
				}
			}]    
		});   
		*/
	}
	var LoadPopover=(function(){
		///防止多次初始化数据
		var AlreadLoadObj={};	//初始化元素
		var AlreadShowObj={};	//初始化显示数据
		return function(Type,ID){
			if (Type=="Load"){
				if (typeof AlreadLoadObj[ID] =="undefined"){
					AlreadLoadObj[ID] ="1";
					return true;
				}else{
					return false;
				}
			}else if (Type=="Show"){
				if (typeof AlreadShowObj[ID] =="undefined"){
					AlreadShowObj[ID] ="1";
					return true;
				}else{
					return false;
				}
			}else if (Type=="Clear"){
				 AlreadLoadObj={};	//初始化元素
				 AlreadShowObj={};
			}
			
		}
	})();
	
	function showPannelWin(){
		var PannelObj=$(this).next();
		var Currid=$(this).attr("id");
		if (PannelObj.length==0){
			var Height="";
			var Width="";
			var title="";
			if ((Currid=="Diet")||(Currid=="Drainage")||(Currid=="TendOrd")){
				Height="200px",Width="100px";
				title=$g("请设置标题");
			}else if ((Currid=="BloodPressure")||(Currid=="Temperature")||(Currid=="Pulse")){
				Height="400px",Width="600px";
				title=$g("请设置标题");
			}else if ((Currid=="Lab")||(Currid=="Exam")){
				Height="300px",Width="700px";
				if (Currid=="Lab"){
					if ($("#LabCount").text()==0){return false;}
				}else if (Currid=="Exam"){
					if ($("#ExamCount").text()==0){return false;}
				}
			}else if (Currid=="CVReport"){
				if ($("#CVReport").text()==0){
					return false;
				}
				Height="300px",Width="700px";
			}else{
				Height="300px",Width="500px";
				title=$g("请设置标题");
			}
			var HTML=GetPannelHTML(Currid);
			//$("#ShowPanel").panel("setTitle",title);
			var PannelClone=$("#ShowPanel").clone();
			PannelClone.attr('id',$(this).attr('id')+'Pannel')
			.css('height',Height)
			.css('width',Width)
			.append(HTML.innerHTML);
			$(this).parent().append(PannelClone);
			
			if (typeof HTML.CallFunction == "function"){
				HTML.CallFunction.call();
			}
			
			var PannelObj=$(this).next();
		}
		
		PannelObj.show();
		return;
	}
	function hidePannelWin(){
		var PannelObj=$(this).next();
		PannelObj.hide();
	}

	///获取动态写入的HTML代码
	function GetPannelHTML(LinkID){
		var innerHTML="";
		var CallFunction={};
		var Title="";
		var width=200,height=150
		if ((LinkID=="TendOrd")||(LinkID=="Diet")||(LinkID=="Drainage")){
			if (ServerObj.PracticeFlag=="1"){
				return {
					"innerHTML":innerHTML,
					"CallFunction":CallFunction,
					"Title":Title
				}
			}
			///护理级别、饮食、引流
			if (LinkID=="TendOrd"){
				Title=$g("护理级别选择");
				//width=150 //,height=120;
				width='auto' //,height='auto';
			}else if (LinkID=="Diet"){
				Title=$g("饮食医嘱");
				width=200
			}else if (LinkID=="Drainage"){
				Title=$g("引流医嘱");
				width=200
			}
			var JsonData=tkMakeServerCall("web.DHCDocInPatPortalCommon","GetAdmOrdClassifyDetailJson",ServerObj.EpisodeID,LinkID);
			var JsonData=eval("("+JsonData+")");
			innerHTML+='<ul style="list-style-type:none">';
			var CurrArcimDR="",OrdItem="";
			if (JsonData.length>0){
				for (var i=0,length=JsonData.length;i<length;i++) {
					var Desc=JsonData[i].Desc;
					var DescLen=Desc.length*16;
					if(DescLen>width){
						width=DescLen;	
					}
					var Value=JsonData[i].Value;
					var Checked=JsonData[i].Checked;
					//<input value="ALL" class='hisui-radio' type="radio" data-options="label:'全部',name:'PriorType_Radio',check:true">
					innerHTML+='<li>';
					/*innerHTML+='<input id="'+LinkID+i+'_Radio" class="hisui-radio" type="radio" value="'+Value+'" data-options="label:\''+Desc+'\',name:\''+LinkID+'_Radio\''*/
					innerHTML+="<input class='hisui-radio ord-radio' type='radio' value='"+Value+"' label='"+Desc+"' name='"+LinkID+'_Radio'  //+"'>"
					if (Checked=="1"){
						CurrArcimDR=Value;
						OrdItem=JsonData[i].OrdItem;
						//innerHTML+=',checked:true">';
						innerHTML+="' data-options='checked:true'>"
					}else{
						//innerHTML+='">';
						innerHTML+="'>";
					}
					innerHTML+='</li>'
				}
			}else{
				return {"innerHTML":""};
			}
			innerHTML+='</ul>'; 
			if ((ServerObj.VisitStatus!="P")&&(ServerObj.LoginAdmLocFlag=="Y")) {
				innerHTML+='<div style="text-align:center;margin-top: 10px;"><a id="'+LinkID+'_Btn" CurrOrdItem="'+OrdItem+'" CurrArcimDR="'+CurrArcimDR+'" onclick="ipdoc.pattreatinfo.view.ChangeOrdHandle(this,\''+LinkID+'\')" class="hisui-linkbutton" href="#">保存</a></div>'
			}
			CallFunction=function(){
				$HUI.radio("input.ord-radio",{});
				//$HUI.linkbutton(".hisui-linkbutton",{});
				$HUI.linkbutton($("a[id$='_Btn']"),{});
			};
			//height=(JsonData.length)*40;
			//炫彩与极简按钮高度不一致
			height=(JsonData.length)*22+40+(HISUIStyleCode != "lite"?2:0);
			if (JsonData.length==0){height=0;}
		}else if (LinkID=="OrderKind"){
			//特殊护理
			if ($("#OrderKind").text()!=$g("无")){
				innerHTML+='<table id="OrderKindGrid"></table>'
				CallFunction=LoadOrdKindGrid;
				width=500,height=300;
			}
		}else if ((LinkID=="Temperature")||(LinkID=="BloodPressure")||(LinkID=="Pulse")||(LinkID=="TPRData")){
			///体温、脉搏、血压
			innerHTML+='<div id="NursingCharts'+LinkID+'" style="width: 760px;height:300px;"></div>'
			CallFunction=function(){
				LoadNursingCharts("NursingCharts"+LinkID);
			};
			Title=$g("生命体征");
			width=780,height=300
		}else if (LinkID=="EkgOrd"){
			///心电监测
			if ($("#EkgOrd").text()!=$g("无")){
				innerHTML+='<table id="EkgOrdGrid"></table>';
				CallFunction=LoadEkgOrdGrid;
				width=850,height=300
			}	
		}else if (LinkID=="Lab"){
			//检验
			if ($("#LabCount").text()>0){
				innerHTML+='<table id="LabOrdGrid"></table>';
				CallFunction=LoadLabOrdGrid;
				width=760,height=300
			}
		}else if (LinkID=="Exam"){
			//检查
			if ($("#ExamCount").text()>0){
				innerHTML+='<table id="ExamOrdGrid"></table>';
				CallFunction=LoadExamOrdGrid;
				width=850,height=300
			}
		}else if (LinkID=="CVReport"){
			//危急值
			if ($("#CVReport").text()>0){
				innerHTML+='<table id="CVReportGrid"></table>';
				CallFunction=LoadCVReportGrid;
				width=550,height=300
			}
		}else if (LinkID=="DocCureApp"){
			//治疗申请
			if ($("#DocCureApp").text()>0){
				innerHTML+='<table id="DocCureAppGrid"></table>';
				CallFunction=LoadDocCureAppGrid;
				width=850,height=300
			}
		}
		return {
			"innerHTML":innerHTML,
			"CallFunction":CallFunction,
			"Title":Title,
			"width":width,
			"height":height
		}
	}
	///切换医嘱
	ChangeOrdHandle = function(valueObj,LinkID){
		var LinkObj=$("#"+LinkID);
		var LinkText=LinkObj.html();
		var valueObj=$(valueObj);
        var CurrArcimDR=valueObj.attr('CurrArcimDR');
        var CurrOEORD=valueObj.attr('CurrOrdItem');
        if ((LinkText==$g("无"))||(LinkText=="")){
	        var CurrArcimDR="",CurrOEORD="";
	    }
        var SelOption=$("input[name='"+LinkID+"_Radio']:checked");
        if (SelOption.length==0){
	    	return false;   
	    }
       	var SelArcimDr=SelOption.val();
       	var SelArcimName=SelOption.attr("label") //eval("[{"+SelOption.attr("data-options")+"}]")[0].label;
        var Params=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+LinkID;
        if (("^"+CurrArcimDR+"^").indexOf("^"+SelArcimDr+"^")>=0){
			hidePannelWin.call(valueObj);  
	    }else{
		    var PPRowId=GetMenuPara("PPRowId");
		    var warning = $.cm({
				ClassName:"web.DHCDocInPatPortalCommon",
				MethodName:"CheckBeforeSwitchAdmOrd",
			    EpisodeID:ServerObj.EpisodeID,
			    CurrOrd:CurrOEORD,
			    NewArcimDr:SelArcimDr,
			    PPRowId:PPRowId,
				dataType:"text"
			},false);
			if (warning!=""){
				$.messager.alert("提示",warning);
				return false;
			}
		    $.m({
			    ClassName:"web.DHCDocInPatPortalCommon",
			    MethodName:"SwitchAdmOrd",
			    EpisodeID:ServerObj.EpisodeID,
			    CurrOrd:CurrOEORD,
			    NewArcimDr:SelArcimDr,
			    Params:Params,
			    PPRowId:PPRowId,
			},function(val){
				var rtn=val.split(String.fromCharCode(2))[0];
				if ((rtn=="100")||(rtn=="0")){
					var mesg=val.split(String.fromCharCode(2))[1];
					if (mesg=="") mesg=rtn;
					$.messager.alert("提示",'切换医嘱失败，错误代码:'+mesg);
					return false;
				}else{
					var OrdList=val.split(String.fromCharCode(2))[0];
					var ArcimDrList=val.split(String.fromCharCode(2))[1];
					var ArcimDescList=val.split(String.fromCharCode(2))[2];
					valueObj.attr('CurrArcimDR',ArcimDrList).attr('CurrOrdItem',OrdList);
					LinkObj.text(ArcimDescList);
					//LinkObj.text(SelArcimName);
					//valueObj.attr('CurrArcimDR',SelArcimDr).attr('CurrOrdItem',val.split("^")[0].split("*")[1]);
					if (typeof ipdoc.patord.view =='object'){
						ipdoc.patord.view.LoadPatOrdDataGrid("");
					}
				}
				hidePannelWin.call($(valueObj));
			});
		}
    }
    ///加载医嘱分类树状列表
    function LoadOrdKindGrid(){
		var OrderKindColumns=[[    
			{field:'RowID', hidden:true},  
	        {title:'标题',field:'Title',width:180},
	        {field:'ARCIMDR',hidden:true},
	        {field:'OEOrder',hidden:true},
	        {title:'医嘱项名称',field:'ArcimDesc',width:180}
	    ]];
	    $.m({
		    //ClassName:"web.DHCDocInPatPortalCommon",
		    ClassName:"DHCDoc.DHCDocConfig.OrderClassify",
		    MethodName:"LoadOrderKind",
		    EpisodeID:ServerObj.EpisodeID
		},function(val){
			var GridData=eval('(' + val + ')'); 
			$HUI.treegrid('#OrderKindGrid',{
			    data:GridData,
			    idField:'RowID',
			    treeField:'Title',
			    title:$g('特殊医嘱分类'),
			    headerCls:'panel-header-gray',
			    fit : false,
			    width:400,
			    height:300,
			    border: false,   
			    columns:OrderKindColumns
			});
		});
    }
    
    function LoadLabOrdGrid(){
		var LabOrdColumns=[[    
			{field:'Index', hidden:true},
			{title:'状态',field:'Title',width:150},
			{title:'医嘱名称',field:'ARCIMDesc',width:200},
			{title:'医嘱名称',field:'TestSetName',width:250,hidden:true},
			{title:'状态',field:'Status',hidden:true},
			{title:'医嘱id',field:'OrderId',width:90,hidden:true},
			{title:'报告id',field:'ReportId',width:90,hidden:true},
			{title:'检验号',field:'VisitNumber',width:110,hidden:true},
			{title:'采血时间',field:'SpecCollDate',width:90},
			{title:'申请时间',field:'RequestTime',width:90,hidden:true},
			{title:'接收时间',field:'ReceiveTime',width:90},
			{title:'报告时间',field:'ReportTime',width:90},
			{title:'报告链接',field:'labReportLink',width:70,
				formatter:function(value,rec){
	 				var BtnHTML="";
	 				 ///已申请 1 ，已接收 2 ，已报告 3
	 				if (rec.Status!="3"){
		 				return BtnHTML;
		 			}else{
			 			var BtnHTML = '<a class="editcls" onclick="ipdoc.pattreatinfo.view.OpenLabReport(\'' + rec.OrderId + '\')">操作</a>';
			 		}
			       return BtnHTML;
                }
			}
	    ]];
		$('#LabOrdGrid').treegrid({
			url:$URL,
			title:$g('检验列表'),
			headerCls:'panel-header-gray',
			idField:'Index',
			treeField:'Title',
			fit : false,
			width:740,
			height:300,
			border: true,
			toolbar:[],
			columns:LabOrdColumns,
			onBeforeLoad:function(node,param){
				param.ClassName="web.DHCDocInPatPortalCommon";
				param.MethodName="GetLabGridData";
				param.EpisodeID=ServerObj.EpisodeID;
				param.UserId=session['LOGON.USERID'];
			}
		});
	}
    ///检查医嘱分类树状列表
    function LoadExamOrdGrid(){
		var ExamOrdColumns=[[    
			{field:'Index', hidden:true},
			{title:'状态',field:'Title',width:90},
	        {field:'OEORowid',hidden:true},
	        {title:'医嘱项名称',field:'ItemDesc',width:250},
	        {title:'部位/标本',field:'BodyPart',width:150},
	        {title:'检查号',field:'StudyNo',width:60,hidden:true},
	        {title:'执行科室',field:'ExecuteLoc',width:80},
	        {title:'状态',field:'ReportStatus',hidden:true},
	        {title:'时间',field:'DateTime',width:150},
	        {title:'医师',field:'AppDoc',width:80,hidden:true},
	        {title:'报告链接',field:'ExamReportLink',width:70,
				formatter:function(value,rec){
	 				var BtnHTML="";
	 				 ///已申请 A ，（"登记"、"预约"） ，已报告 C
	 				if (rec.ReportStatus!="C"){
		 				return BtnHTML;
		 			}else{
			 			var BtnHTML = '<a class="editcls" onclick="ipdoc.pattreatinfo.view.OpenExamReport(\'' + rec.OEORowid + '\')">操作</a>';
			 		}
					return BtnHTML;
                }
			}
	    ]];
		$HUI.treegrid('#ExamOrdGrid',{
			url:$URL,
			title:$g('检查列表'),
			headerCls:'panel-header-gray',
			idField:'Index',    
			treeField:'Title',
			fit : false,
			width:830,
			height:300,
			border: true,   
			toolbar:[],
			columns:ExamOrdColumns,
			onBeforeLoad:function(node,param){
				param.ClassName="web.DHCDocInPatPortalCommon";
				param.MethodName="GetExamGridData";
				param.EpisodeID=ServerObj.EpisodeID;
				param.UserCode=session['LOGON.USERCODE'];
			}
		});
	}
	
	function LoadEkgOrdGrid(){
		 var EkgOrdColumns=[[    
			{field:'Index', hidden:true},
			{field:'OeordId', hidden:true},
	        {title:'医嘱名称',field:'ArcimDesc',width:200},
	        {title:'报告状态',field:'ReportState',width:80},
	        {title:'结果',field:'Negative', width:40},
	        {title:'诊断结论',field:'Diagnose', width:200,
				formatter: function(value,row,index){
					return '<span title="'+value+'">'+value+'</span>';
			}},
	        {title:'医生姓名',field:'DoctorName',width:100},
	        {title:'报告时间',field:'ReportTime', width:120},
	        {title:'报告状态',field:'ReportStatus', hidden:true},
	        {title:'医生工号',field:'DoctorId', hidden:true},
	        {field:'URL', hidden:true},
	        {title:'明细',field:'CVReportBtn',
 				formatter:function(value,rec){
	 				var BtnHTML="";
	 				if (rec.URL==""){
		 				var BtnHTML = '';
		 			}else{
			 			var URL=rec.URL;
			 			URL=URL+"&USERID="+session['LOGON.USERID'];
			 			var BtnHTML = '<a class="editcls" onclick="ipdoc.pattreatinfo.view.EkgReportBtnClickHandler(\'' + URL + '\')">操作</a>';
			 		}
                   
			       return BtnHTML;
                }
 			}
	    ]];
		$HUI.datagrid('#EkgOrdGrid',{
			url:$URL,
			title:$g('心电监测'),
			headerCls:'panel-header-gray',
			idField:'Index',
			fit : false,
			width:820,
			height:300,
			border: false,
			columns:EkgOrdColumns,
			onBeforeLoad:function(param){
				param.ClassName="web.DHCDocInPatPortalCommon";
				param.QueryName="QueryEkgOrdList";
				param.EpisodeID=ServerObj.EpisodeID;
				param.UserID=session['LOGON.USERID'];
			}
		});  
	}
    function LoadCVReportGrid(){
		var CVReportColumns=[[    
			{field:'Index', hidden:true},
			{title:'报告ID',field:'ReportId', hidden:true},
	        {title:'医嘱名称',field:'TSName',width:233},
	        {title:'危急值类型名称',field:'ReportType',width:120},
	        {title:'危急值类型代码',field:'DPRPType', hidden:true},
	        {title:'警示提示',field:'DPRPAlert',width:120},
	        {title:'报告状态',field:'ReportStatus', hidden:true},
	        {title:'报告日期',field:'DateTime', hidden:true},
	        {title:'申请日期',field:'ApplyDT', hidden:true},
	        {title:'采样时间',field:'SamplingDT', hidden:true},
	        {title:'接收时间',field:'ReceiveDT', hidden:true},
	        {title:'审核时间',field:'AuditDT', hidden:true},
	        {title:'标本',field:'Specimen', hidden:true},
	        {title:'操作',field:'CVReportBtn',width:50,
 				formatter:function(value,rec){
                   var btn = '<a class="editcls" onclick="ipdoc.pattreatinfo.view.CVReportBtnClickHandler(\'' + rec.ReportId + '\',\'' + rec.DPRPType + '\')">操作</a>';
			       return btn;
                }
 			},
	    ]];
		$HUI.datagrid('#CVReportGrid',{
			url:$URL,
			title:$g('危急值'),
			headerCls:'panel-header-gray',
			idField:'Index',
			treeField:'Title',
			fit : false,
			width:530,
			height:300,
			border: true,
			toolbar:[],
			columns:CVReportColumns,
			onBeforeLoad:function(param){
				param.ClassName="web.DHCCVCommon";
				param.QueryName="CVReportFromAdm";
				param.EpisodeId=ServerObj.EpisodeID;
				param.TransStatus="C";
			}
		});
	}
	function LoadDocCureAppGrid(){
		var DocCureColumns=[[ 
			{field:'Index',title:'Index',width:30,hidden:true},
			{field:'DCARowId',title:'DCARowId',width:30,hidden:true},
			{field:'ApplyStatus',title:'申请状态',width:100,align:'left', resizable: true},
			{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true},  
			{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
			{field:'OrdOtherInfo',title:'医嘱其他信息',width:120,align:'left', resizable: true},
			{field:'ApplyPlan',title:'治疗方案',width:80,align:'left',
				formatter:function(value,row,index){
					if(row.DCARowId==""){
						return "";
					}else{
						if (value == "") {
							return "<span style='background:#29B66A;color:#fff;padding:2px 4px;border-radius:4px;display:inline-block;'>"+$g("未填写")+"</span>";
						}else {
							var Type="'Plan'";
							return '<a href="###" id= ApplyPlan"'+row["DCARowId"]+'"'+' onclick=DHCDocCure_InpatTreat_Service.ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span style='background:#40A2DE;color:#fff;padding:2px 4px;border-radius:4px;display:inline-block;'>"+$g("单击查看")+"</span>"+"</a>"
						}
					}
				}
			},
			{field:'ApplyAssessment',title:'治疗评估',width:80,align:'left',
				formatter:function(value,row,index){
					if(row.DCARowId==""){
						return "";
					}else{
						if (value == "") {
							return "<span style='background:#29B66A;color:#fff;padding:2px 4px;border-radius:4px;display:inline-block;'>"+$g("未填写")+"</span>";
						}else {
							var Type="'Ass'";
							return '<a href="###" id= ApplyAssessment"'+row["DCARowId"]+'"'+' onclick=DHCDocCure_InpatTreat_Service.ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span style='background:#40A2DE;color:#fff;padding:2px 4px;border-radius:4px;display:inline-block;'>"+$g("单击查看")+"</span>"+"</a>"
						}
					}
				}
			},
			{field:'DCRecord',title:'治疗记录',width:80,align:'left',
				formatter:function(value,row,index){
					if(row.DCARowId==""){
						return "";
					}else{
						if (value == "") {
							return "<span style='background:#29B66A;color:#fff;padding:2px 4px;border-radius:4px;display:inline-block;'>"+$g("未填写")+"</span>";
						}else {
							var Type="'Record'";
							return '<a href="###" id= DCRecord"'+row["TIndex"]+'"'+' onclick=DHCDocCure_InpatTreat_Service.ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span style='background:#40A2DE;color:#fff;padding:2px 4px;border-radius:4px;display:inline-block;'>"+$g("单击查看")+"</span>"+"</a>"
						}
					}
				}
			},
			{field:'OrdQty',title:'数量',width:50,align:'left', resizable: true}, 
			{field:'OrdBillUOM',title:'单位',width:50,align:'left', resizable: true}, 
			{field:'OrdUnitPrice',title:'单价',width:50,align:'left', resizable: true}, 
			{field:'OrdPrice',title:'总金额',width:60,align:'left', resizable: true}, 
			{field:'ApplyAppedTimes',title:'已预约次数',width:80,align:'left', resizable: true},
			{field:'ApplyNoAppTimes',title:'未预约次数',width:80,align:'left', resizable: true},
			{field:'ApplyFinishTimes',title:'已治疗次数',width:80,align:'left', resizable: true},
			{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80,align:'left', resizable: true},
			{field:'OrdBilled',title:'是否缴费',width:70,align:'left', resizable: true,
				styler: function(value,row,index){
					if (value == "否"){
						return 'background-color:#ffee00;color:red;';
					}
				}
			},
			{field:'OrdReLoc',title:'接收科室',width:80,align:'left', resizable: true},   
			{field:'ServiceGroup',title:'服务组',width:80,align:'left', resizable: true}, 
			//{field: 'ApplyExec', title: '是否可预约', width: 80, align: 'left',resizable: true},
			{field:'ApplyUser',title:'申请医生',width:80,align:'left', resizable: true},
			{field:'ApplyDateTime',title:'申请时间',width:160,align:'left', resizable: true}
		]]
		$HUI.treegrid('#DocCureAppGrid',{
			url:$URL,
			title:'治疗申请',
			headerCls:'panel-header-gray',
			idField:'Index',
			treeField:'ApplyStatus',
			fit : false,
			width:820,
			height:300,
			border: true,
			toolbar:[],
			columns:DocCureColumns,
			onBeforeLoad:function(node,param){
				param.ClassName="DHCDoc.DHCDocCure.Service";
				param.MethodName="GetCureAppGridData";
				param.EpisodeID=ServerObj.EpisodeID;
			}
		});
	}
    
    function formatBloodPressure(params, MsgType){
        var BloodPressure=params.value;
        if (BloodPressure==""){
            return "";
        }
        var SysLength=(BloodPressure+"").substr(5,1);
        var SysPressure=(BloodPressure+"").substr(6,SysLength);
        var Sysdecimal=(SysPressure+"").substr(SysLength-1,1);
        	SysPressure=(SysPressure+"").substr(0,SysLength-1);
        if (Sysdecimal>0) {
	        SysPressure=insertDecimal(SysPressure,Sysdecimal-1,"."); //insert_flg(SysPressure,".",Sysdecimal-1);
	    }
        var DiaLength=(BloodPressure+"").substr(6+parseFloat(SysLength),1);
        var DiaPressure=(BloodPressure+"").substr(6+parseFloat(SysLength)+1,DiaLength);
        var Diadecimal=(DiaPressure+"").substr(DiaLength-1,1);
            DiaPressure=(DiaPressure+"").substr(0,DiaLength-1);
        if (Diadecimal>0) {
	        DiaPressure=insertDecimal(DiaPressure,Diadecimal-1,".");
	    }
        var CruuDate=params.name;
        var Msg="";
        if (MsgType=="Lable"){
            Msg=SysPressure+"\n/\n"+DiaPressure;

        }else if (MsgType=="tip"){
            Msg=$g("日期:")+CruuDate+"</br>"+$g("血压:")+SysPressure+"/"+DiaPressure
        }
        return Msg;
        function insertDecimal(soure, start, newStr){
			return soure.slice(0, start) + newStr + soure.slice(start);
		}
    };
    function CVReportBtnClickHandler(ReportId,DPRPType){
	    //var Url="criticalvalue.trans.csp?ReportId="+ReportId+"&RepType="+DPRPType;
		var Url="criticalvalue.trans.hisui.csp?ReportId="+ReportId+"&RepType="+DPRPType;
		//window.open(Url, "", "status=1,scrollbars=1,top=100,left=100,width=860,height=560");
		websys_showModal({
			url:Url,
			iconCls:'icon-w-paper',  
			title:'危急值处理',
			width:'90%',height:'90%'
		})
	}
	function EkgReportBtnClickHandler(URL){
		//window.open(URL, "", "status=1,scrollbars=1,top=100,left=100,width=760,height=500");
		websys_showModal({
			url:URL,
			title:'心电结果明细',
			width:'90%',height:'90%'
		})
	}
    ///护理图标
    function LoadNursingCharts(ChartsID){
		///NursingCharts
		var myChart = echarts.init(document.getElementById(ChartsID));
		///体温、脉搏测量时间列 必须是每日五个时间段
		var dataAxis1;
		///血压测量时间列，必须是每日两个时间段
		var dataAxis2;
		///体温
		var TemperatureJson;
		///脉搏
		var PulseJson;
		///血压
		var BloodPressureJson;
		option = {
            color: ['#3398DB'],
            tooltip : {
                trigger: 'axis',

                axisPointer : {
                    type : 'shadow'
                }
            },
            
            legend: {
                data:[$g('体温℃'),$g('脉搏')]
            },
            grid: [{
                    left: 50,
                    right: 50,
                    height: '45%'
                },{
                    left: 50,
                    right: 50,
                    top: '65%',
                    height: '27%'
                }
            ],
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    data : '',
                    gridIndex: 0,
                    position:'top',
                    axisTick: {
                        show: true,
                        interval: 'auto',
                        alignWithLabel: false
                    },
                    splitLine:{
                        show:true,
                        interval:0,//隔0个显示一次竖线
                        lineStyle:{
	                        //,需要自动计算
                            color: ['#21BA45','#CCCCCC','#CCCCCC','#CCCCCC','#CCCCCC','#CCCCCC']
                        }
                    },
                    axisLabel: {
                        show: true,
                        interval:5 //隔5个显示一次坐标,需要自动计算
                        //rotate:20
                    }
                },{
                    gridIndex: 1,
                    data: '',
                    type : 'category',
                    position:'top',
                    axisTick: {
                        show: false
                    },
                    splitLine:{
                        show:true,
                        interval:0,
                        lineStyle:{
                            color: ['#21BA45','#CCCCCC']
                        }
                    },
                    axisLabel: {
                        show: false
                    }
                }
            ],
            yAxis : [
                {
					type: 'value',
					name: $g('体温℃'),
                    gridIndex: 0,
					min: 34,
					max: 41,
					nameLocation:'end',
					offset:0,
					nameGap:25,
					interval:1,
					position: 'left',
					axisLabel: {
						formatter: '{value}'
					}
                },{
                    type: 'value',
                    name: $g('脉搏(次/分)'),
                    nameGap:25,
                    gridIndex: 0,
                    min: 20,
                    max: 160,
                    nameLocation:'end',
                    offset:0,
                    position: 'right',
                    interval:20
                },{
                    gridIndex: 1,
                    name : $g('血压'),
                    type : 'value',
                    min: 0,
                    max: 1,
                    nameLocation:'middle',
                    nameRotate:0,
                    interval:1,
                    inverse: true,
                    axisTick: {
                        show: false
                    },
                    axisLabel: {
                        show: false
                    }
                }
            ],
            series : [
                {
                    name:$g('体温℃'),
                    type:'line',
                    barWidth: '20%',
					symbolSize: 4,
					showAllSymbol: true,
					smooth: true,
					connectNulls: true,
                    //step: 'end',	拐点方式
                    itemStyle:{normal:{color:'#d14a61'}},
                    data:''
                },{
					name:$g('脉搏'),
					type:'line',
					yAxisIndex: 1,
					symbolSize: 4,
					showAllSymbol: true,
					smooth: true,
					connectNulls: true,
                    itemStyle:{normal:{color:'#5BC0DE'}},
					data:''
                },{
                    name:$g('血压'),
                    type:'bar',
                    yAxisIndex: 2,
                    xAxisIndex: 1,
                    label: {
                        normal: {
                            show: true,
                            position: 'insideTop',
                            fontSize:5,
                            color:'#333333',
                            formatter:function (params, ticket, callback){
                                return ipdoc.pattreatinfo.view.formatBloodPressure(params,"Lable");
                            } //'{a}:{b}:{c}:{d}'
                        }
                    },
                    itemStyle: {
                        normal: {
                            opacity:0.8
                        }
                    },
                    barWidth:'100%',
                    barMinHeight:'1',
                    tooltip: {
                        trigger:'item',
                        formatter:function (params, ticket, callback){
                                return ipdoc.pattreatinfo.view.formatBloodPressure(params,"tip");
                        }
                    },
                    data:''
                }
            ]
        };
        $.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"LoadNursingData",
		    EpisodeID:ServerObj.EpisodeID
		},function(val){
			var result=eval('(' + val + ')'); 
			option.xAxis[0].data=result[0].dataAxis1.split(',');
			option.xAxis[1].data=result[0].dataAxis2.split(',');
			option.series[0].data=result[0].TempStr.split(',');
			option.series[1].data=result[0].PulseStr.split(',');
			option.series[2].data=result[0].BloodPreStr.split(',');
			//自动计算彩色竖线及X轴显示标签
			option.xAxis[0].axisLabel.interval=parseFloat(result[0].MaxNumTime)-1;
			var color = new Array();
			color.push('#21BA45');
			for (var i=0;i<option.xAxis[0].axisLabel.interval;i++) {
				color.push('#CCCCCC');
			}
			option.xAxis[0].splitLine.lineStyle.color=color;
			
            // 使用刚指定的配置项和数据显示图表。
    		myChart.setOption(option);
		});
        
	};
	//复制一份图标，直接复写元素图标的html不显示数据，还是要重新load
	function CopyNursingCharts(NewNursingChartsID){
		var NursingCharts= echarts.getInstanceByDom(document.getElementById('NursingCharts'));
		var myCharts=echarts.init(document.getElementById('NursingCharts'+NewNursingChartsID));
		myCharts.setOption(NursingCharts.getOption());
	}
	//打开检验报告
	function OpenLabReport(OrderId){
		//alert(OrderId)
		if (typeof parent.switchTabByEMR =="function"){
			parent.switchTabByEMR("dhcapp_seepatlis_IP",{"oneTimeValueExp":"OEORIID="+OrderId});
		}
	}
	//打开检查报告
	function OpenExamReport(OrderId){
		if (typeof parent.switchTabByEMR =="function"){
			parent.switchTabByEMR("dhcem_inspectrs",{"oneTimeValueExp":"OEORIID="+OrderId}); //dhc_side_find_rislist
		}
	}
	//临床路径图标点击事件
	function ClinicalIconClick(Type){
		//1:打开临床路径菜单；2:打开医嘱录入菜单
		if (typeof parent.switchTabByEMR !="function"){
			return;
		}
		if (Type=="1"){
			parent.switchTabByEMR($g("临床路径"));
		}else if ((Type=="2")||(Type=="3")){
			if (Type=="2"){
				var tabName=$g("医嘱录入");
			}else if (Type=="3"){
				var tabName=$g("中草药录入");
			}
			parent.switchTabByEMR(tabName);
			var intervalTime=0
			var intervalId = setInterval(function() {
				intervalTime=intervalTime+1;
				var rtn=parent.invokeChartFun(tabName,"AddCPWOrdClickHandler");
				if ((rtn>=0)||(intervalTime>6)){		//6秒或调用成功后，清空定时器
					clearInterval(intervalId);
				}
			}, 1000);
		}
	}
	function ReLoadPatAdmInfoJson(){
		$.cm({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"GetAdmInfoJson",
		    EpisodeID:ServerObj.EpisodeID, UserCode:session['LOGON.USERCODE'],
		    dataType:"text"
		},function(PatAdmInfoJson){
			PatAdmInfoJson=eval("("+PatAdmInfoJson+")")
			var id,value,valueArr,text,color;
			for (var i=0;i<PatAdmInfoJson.length;i++){
				id=PatAdmInfoJson[i].id;
				value=PatAdmInfoJson[i].Value+"";
				$("#"+id+"").html(value);
			}
		});
		LoadPopover("Clear");
	}
	
    function execScript(e) {
         if (e && /\S/.test(e)) {
            var t = document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0],
            n = document.createElement("script");
            n.type = "text/javascript",
            n.src = e,
            t.insertBefore(n, t.firstChild),
            setTimeout(function() {
                t.removeChild(n)
            },
            1)
        }
    }
	function xhrRefresh(){
		LoadPopover("Clear");
		//$(".webui-popover").remove();
		$(PopoverList).each(function(){
			$(this).popover('destroy');
		});
		///ServerObj.PatAdmInfoJson在InfoOrder.js->InitPatOrderViewGlobal统一刷新，减少请求
		InitPatAdmInfo();
		$("#AddEMRRecord").click(AddEMRRecordClickHandle);
	}
	///得到菜单参数
	function GetMenuPara(ParaName) {
	    var myrtn = "";
	    var frm = dhcsys_getmenuform();
	    if (frm) {
		    if (eval("frm." + ParaName)){
	        	myrtn = eval("frm." + ParaName + ".value");
	        }
	    }
	    return myrtn;
	}
	return {
		"InitPatAdmInfoJson":InitPatAdmInfoJson,
		"ChangeOrdHandle":ChangeOrdHandle,
		"formatBloodPressure":formatBloodPressure,
		"CVReportBtnClickHandler":CVReportBtnClickHandler,
		"EkgReportBtnClickHandler":EkgReportBtnClickHandler,
		"OpenLabReport":OpenLabReport,
		"OpenExamReport":OpenExamReport,
		"ClinicalIconClick":ClinicalIconClick,
		"ReLoadPatAdmInfoJson":ReLoadPatAdmInfoJson,
		"xhrRefresh":xhrRefresh
	}
})();