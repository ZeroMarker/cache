var objScreen = new Object();
function InitRep(obj){

	obj.zyTitle=$g('摘要');
	//初始化感染报告易感因素信息
	obj.PreFactor = $cm({
		ClassName:"DHCHAI.BTS.PreFactorSrv",
		QueryName:"QueryPreFactor",	
		aIsNewborn:1,		
		aActive:1
	},false)
	var Prelen = obj.PreFactor.total;
	var Prelen = obj.PreFactor.total;
	function sortarr(attr){
		return function(a,b) {
			return a[attr]-b[attr]	
		}
	}
	obj.PreFactor.rows.sort(sortarr('BTIndNo'));
	for (var m = 0; m < Prelen; m++) {
		var PreFactorID = obj.PreFactor.rows[m].ID;
		var PreFactorDesc = obj.PreFactor.rows[m].BTDesc;
		//处理特殊字符
		PreFactorDesc = PreFactorDesc.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
		$("#chkPreFactor").append(
			 "<div style='float:left;width:12.5%'><input id=chkPreFactor"+PreFactorID+" type='checkbox' class='hisui-checkbox' "+" label="+PreFactorDesc+" name='chkPreFactor' value="+PreFactorID+"></div>"
		);
	}	
	$.parser.parse('#chkPreFactor');  //解析checkbox	
	
	//初始化感染报告侵害性操作信息
	obj.InvasOper = $cm({
		ClassName:"DHCHAI.BTS.InvasOperSrv",
		QueryName:"QueryInvasOper",		
		aActive:1
	},false)
	var Invlen = obj.InvasOper.total;
	
	for (var n = 0; n < Invlen; n++) {
		var InvasOperID = obj.InvasOper.rows[n].ID;
		var InvasOperDesc = obj.InvasOper.rows[n].BTDesc;
		$("#chkInvasOper").append(
			 "<div style='float:left;width:12.5%'><input id=chkInvasOper"+InvasOperID+" type='checkbox' class='hisui-checkbox' "+" label="+InvasOperDesc+" name='chkInvasOper' value="+InvasOperID+"></div>"
		);
	}	
	$.parser.parse('#chkInvasOper');  //解析checkbox	
		
	obj.refreshReportInfo = function(){
		// 初始化报告主表信息
		obj.RepInfo = $cm({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			QueryName:"QryRepInfo",		
			aRepotID: ReportID
		},false);
		if (obj.RepInfo.total>0) {
			var RepInfo = obj.RepInfo.rows[0];
			$('#txtRepDate').val(RepInfo.RepDate+ ' ' + RepInfo.RepTime);
			$('#txtRepLoc').val(RepInfo.RepLoc);
			$('#txtRepUser').val(RepInfo.RepUser);
			$('#txtRepStatus').val(RepInfo.RepStatus);
			obj.RepStatusCode = RepInfo.RepStatusCode;
			var  IsInfLab = RepInfo.IsInfLab;
			var  IsInfAnti = RepInfo.IsInfAnti;
			var  IsInfOpr = RepInfo.IsInfOpr;
			var  Opinion = RepInfo.Opinion;
			if (IsInfLab) {
				$HUI.radio("#radInfLab-"+IsInfLab).setValue(true);
			}
			if (IsInfAnti) {
				$HUI.radio("#radInfAnti-"+IsInfAnti).setValue(true);
			}
			if (IsInfOpr) {
				$HUI.radio("#radInfOpr-"+IsInfOpr).setValue(true);
			}
			if (Opinion) {
				$('#txtOpinion').val(Opinion);
			}
		}
				
		//加载数据
		obj.InfPreFactor = $cm({
			ClassName:"DHCHAI.IRS.INFPreFactorSrv",
			QueryName:"QryPreFactorByRep",	
			aReportID:ReportID,		
			aEpisodeID:EpisodeID
		},false);
		
		for (var j=0;j<obj.InfPreFactor.total;j++){
			var PreFactorDicID = obj.InfPreFactor.rows[j].PreFactorID;
			var PreFactorID = obj.InfPreFactor.rows[j].ID;
			var selector = '#chkPreFactor'+PreFactorDicID;
			$(selector).attr('dataID',PreFactorID);
			$(selector).checkbox('setValue',true);
		}
		obj.InfInvasOper = $cm({
			ClassName:"DHCHAI.IRS.INFInvOperSrv",
			QueryName:"QryInvOperByRep",	
			aReportID:ReportID,		
			aEpisodeID:EpisodeID
		},false);
		
		for (var n=0;n<obj.InfInvasOper.total;n++){
			var InvOperDicID = obj.InfInvasOper.rows[n].InvOperID;
			var InvOperID = obj.InfInvasOper.rows[n].ID;
			var selector = '#chkInvasOper'+InvOperDicID;
			$(selector).attr('dataID',InvOperID);
			$(selector).checkbox('setValue',true);
		}
		
	}
	obj.refreshReportInfo();

	obj.Rep_Save = function (statusCode){
		var RepDate = '';
		var RepTime = '';
		var RepLoc  = $.LOGON.LOCID;
		var RepUser = $.LOGON.USERID;
        var IsInfLab = Common_RadioValue('radInfLab');
        var IsInfAnti = Common_RadioValue('radInfAnti');
        var IsInfOpr = Common_RadioValue('radInfOpr');
        var Opinion = $('#txtOpinion').val();

		if (obj.AdminPower==1){  //管理员 不修改 报告科室、报告人、报告日期、报告时间 采用报告数据
			if (obj.RepInfo.total>0) { 
				RepDate = obj.RepInfo.rows[0].RepDate;
				RepTime = obj.RepInfo.rows[0].RepTime;
				RepLoc  = obj.RepInfo.rows[0].RepLocID;
				RepUser = obj.RepInfo.rows[0].RepUserID;
			}
		}

		var InputRep = ReportID;
		InputRep = InputRep + CHR_1 + EpisodeID;
		InputRep = InputRep + CHR_1 + 1;
		InputRep = InputRep + CHR_1 + RepDate;
		InputRep = InputRep + CHR_1 + RepTime;
		InputRep = InputRep + CHR_1 + RepLoc;
		InputRep = InputRep + CHR_1 + RepUser;
		InputRep = InputRep + CHR_1 + statusCode;		//状态
		InputRep = InputRep + CHR_1 + IsInfLab;         //是否存在病原学信息
		InputRep = InputRep + CHR_1 + IsInfAnti;        //是否存在抗菌药物信息
		InputRep = InputRep + CHR_1 + IsInfOpr;         //是否存在手术信息
		InputRep = InputRep + CHR_1 + Opinion;          //评价意见
		
    	return InputRep;
	}

	obj.PreFactor_Save = function(){
		// 易感因素
        var PreFactors='';
        $('input:checkbox',$("#chkPreFactor")).each(function(){
       		if(true == $(this).is(':checked')){
            	Input = ($(this).attr("dataID")==undefined?'':$(this).attr("dataID"));
            	Input = Input + CHR_1 + EpisodeID;
    			Input = Input + CHR_1 + $(this).val();
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + $.LOGON.USERID;
    			PreFactors = PreFactors + CHR_2 + Input;
       		}
    	});
    	if (PreFactors) PreFactors = PreFactors.substring(1,PreFactors.length);
    	return PreFactors;
	}

	obj.InvasOper_Save = function(){
		// 侵害性操作
    	var InvasOpers='';
        $('input:checkbox',$("#chkInvasOper")).each(function(){
       		if(true == $(this).is(':checked')){
            	Input = ($(this).attr("dataID")==undefined?'':$(this).attr("dataID"));
            	Input = Input + CHR_1 + EpisodeID;
    			Input = Input + CHR_1 + $(this).val();
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + $.LOGON.USERID;
    			InvasOpers = InvasOpers + CHR_2 + Input;
       		}
    	});
    	if (InvasOpers) InvasOpers = InvasOpers.substring(1,InvasOpers.length);
    	return InvasOpers;
	}

	obj.RepLog_Save = function(statusCode){
		var Opinion = arguments[1];
		if (typeof(Opinion)=='undefined'){
			Opinion='';
		}
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + statusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + Opinion;
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;
    	return InputRepLog;
	}
    //报告编号
    function ShowRepDtl(d,r){
        var aReportID=d.RepID
        var aRepType=d.RepType
        if (aRepType=="1"){
            obj.winOpenInfReport(aReportID);
        }
        if (aRepType=="2"){
            obj.winOpenNewInfReport(aReportID);
        }
        
    }
    objScreen.winOpenInfReport=obj.winOpenInfReport= function(aReportID)
    {
        if (!aReportID) return;
        var url="dhcma.hai.ir.inf.report.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";
    
        //websys_createWindow(strUrl,"newwin","width=1250px,heigth=680px,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=no");
        var oWin = websys_createWindow(url,'',"height=" + (window.screen.availHeight - 130) + ",width=" + 1320 + ",top=0,left=100,resizable=no");
        /*
         websys_showModal({
            url:url,
            title:'医院感染报告',
            iconCls:'icon-w-epr',
            closable:true,
            width:'90%',
            height:'95%',
            onBeforeClose:function(){
                
            }
        }); 
        */
    }
    
    objScreen.winOpenNewInfReport=obj.winOpenNewInfReport = function(aReportID)
    {
        if (!aReportID) return;
        var url="dhcma.hai.ir.inf.nreport.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";
        websys_showModal({
            url:url,
            title:'新生儿医院感染报告',
            iconCls:'icon-w-epr',
            closable:true,
            width:1320,
            height:'95%',
            onBeforeClose:function(){
                
            }
        });
    }
    obj.RepotInfo=""
    //表格-历史已报
    $('#gridReport').datagrid({
        //fit:true,
        
        autoSizeColumn:false,
        fitColumns:true,
        headerCls:'panel-header-gray',
        iconCls:'icon-paper',
        pagination:false,
        rownumbers:true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:false,
        loadMsg:'数据加载中...',
        //是否是服务器对数据排序
        sortOrder:'asc',
        remoteSort:false, 
        url:$URL,
        queryParams:{
            ClassName:"DHCHAI.IRS.INFReportSrv",
            QueryName:"QryRepByAdm",
            aEpisodeID:EpisodeID,
            aRepType:"1"
        },
        pageSize: 20,
        pageList : [20,50,100,200],
        columns:[[
            { field:"RepID",title:"报告编号",width:80,align:'center',sortable:true,sorter:Sort_int},
            { field:"RepStatus",title:"报告状态",width:80,align:'center',sortable:true,sorter:Sort_int,
                formatter:function(value,row,index){
                    var Status=row.RepStatus
                    if (row.RepType=="1") {
                        return '<a href="#"  onclick=objScreen.winOpenInfReport(\''+row.RepID+'\')>'+Status+'</a>';
                    }else if (row.RepType=="2"){
                        return '<a href="#"  onclick=objScreen.winOpenNewInfReport(\''+row.RepID+'\')>'+Status+'</a>';
                    }
                    return Status;
                }
             },
            { field:"InfType",title:"感染类型",width:100,align:'center',sortable:true,sorter:Sort_int
              ,formatter:function(value,row,index){
                    var InfType=row.InfType;
                    var chValue=$g(InfType);  //多语言改造
                    return chValue;
                }
            },
            { field:"InfPosDescs",title:"感染诊断",width:160,align:'center',sortable:true,sorter:Sort_int,tipWidth:200,tipTrackMouse:true},
            { field:"InfDateDescs",title:"感染日期",width:120,align:'center',sortable:true,sorter:Sort_int},
            { field:"InfLocDescs",title:"感染科室",width:120,align:'center',sortable:true,sorter:Sort_int},
            { field:"InfXDate",title:"感染转归日期",width:110,align:'center',sortable:true,sorter:Sort_int},
            { field:"InfEffect",title:"感染转归",width:80,align:'center',sortable:true,sorter:Sort_int},
            { field:"DeathRelation",title:"与死亡关系",width:100,align:'center',sortable:true,sorter:Sort_int},
            { field:"RepLoc",title:"报告科室",width:120,align:'center',sortable:true,sorter:Sort_int},
            { field:"RepDate",title:"报告日期",width:100,align:'center',sortable:true,sorter:Sort_int},
            { field:"RepUser",title:"报告人",width:100,align:'center',sortable:true,sorter:Sort_int},
            { field:"CheckDate",title:"审核日期",width:120,align:'center',sortable:true,sorter:Sort_int},
            { field:"CheckUser",title:"审核人",width:100,align:'center',sortable:true,sorter:Sort_int},
            //{ field:"BactDescs",title:"感染病原体",width:120,align:'center',sortable:true,sorter:Sort_int}
        ]],
        loadFilter:function(data){
            //自定义过滤方法
            /*data.rows=data.rows.filter((item) => {
                return item.RepID != ReportID 
             });
            */
             if (ReportID=="") {
                 return data;
             }
             var len=data.total
             for (var i=0;i<len;i++){
                 if (data.rows[i].RepID==ReportID ){
                     
                    data.rows.splice(i,1)
                    break
                 }
             }
            
            data.total=data.rows.length

            return data; 
        },
        onDblClickRow:function(rindex, rowdata) {
                if (rindex>-1) {
                    ShowRepDtl(rowdata,'');
                
            }
       },onLoadSuccess:function(data){
              obj.RepotInfo=data.rows;   
              if (data.total>=1) {
				   
				}else{
					$("#divbody > div.report-content > div.panel.datagrid").hide()   
				}
       }
    });
    $("#divbody > div.report-content > div.panel.datagrid").show()   
    $("#btnAbstractMsg").click(function(){
        //绑定摘要事件
		var LocFlag=(obj.AdminPowe==1?0:1);
        btnSummer_click(EpisodeID,LocFlag);
    });
    
    
    //摘要
    btnSummer_click = function (EpisodeID,LocFlag,linkId) {
        var t=new Date();
        t=t.getTime();
        var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + EpisodeID +"&LocFlag="+LocFlag+ "&PageType=WinOpen&t=" + t+"&index="+(typeof(linkId)=="undefined"?"":linkId);
        //--打开摘要
        //var page=websys_createWindow(strUrl,"","width=95%,height=95%");
          websys_showModal({
            url:strUrl,
            title:obj.zyTitle,
            iconCls:'icon-w-epr',
            closable:true,
            width:1320,
            height:'95%',
            onBeforeClose:function(){
                
            }
        });
    }
}