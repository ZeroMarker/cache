// underscore 防抖
function debounce(func, wait, immediate) {

    var timeout, result;

    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // 如果已经执行过，不再执行
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };

    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };

    return debounced;
}
var GV={}  ;//存放全局变量
var init=function(){
	GV.maxHeight=$(window).height()||550;
	GV.maxWidth=$(window).width()||1366;
	initTabGroup();
	initTabUser();
	initTabPage();
	$('.window-mask.alldom').fadeOut('fast');
}

var initTabGroup=function(){
	GV.group_cbg=$HUI.combogrid('#group-cbg',{
		width:200,
		disabled:false,
		delay: 500,
		panelWidth:320,
		panelHeight:340,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCMessageOrgMgr',QueryName:'LookUpGroup',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'安全组',width:300},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		onHidePanel:function(){
			search();
		},
		prompt:"选择安全组"
	});
	$('#group-ok').click(function(){
		search();
	})
	var search=function(){
		if(GV.group_cbg!=undefined){
			var val=GV.group_cbg.getValue();
			var text=GV.group_cbg.getText();
			var startdate=$('#group-startdate').datebox('getValue');
			var now=new Date();
			if (startdate=="") {
				startdate=$.fn.datebox.defaults.formatter(now);
				$('#group-startdate').datebox('setValue',startdate);
			}
			var enddate=$('#group-enddate').datebox('getValue');
			if (enddate=="") {
				enddate=$.fn.datebox.defaults.formatter(now);
				$('#group-enddate').datebox('setValue',enddate);
			}
			if (val>0) refreshGroupBar(val,text,startdate,enddate,myChart);
			else  refreshGroupBar("","所有",startdate,enddate,myChart);
		}	
	}
	var refreshGroupBar=function(groupid,groupdesc,startdate,enddate,ecinstance){
		$.q({ClassName:'websys.LogClient',QueryName:'FindPageEventCount',ResultSetType:'array',GroupID:groupid,StartDate:startdate,EndDate:enddate},function(rtn){
			//console.log(rtn);
			var xdata=[],vdata=[];
			$.each(rtn,function(i,o){
				xdata.push(o.pagedesc);
				vdata.push(o.count);
			})
			GV.GroupBarData=rtn;
			if (startdate==enddate) var title=startdate+"  "+groupdesc+"安全组页面事件统计排名";
			else  var title=startdate+" --> "+startdate+"  " +groupdesc+"安全组页面事件统计排名";
			ecinstance.setOption({
				title:{
					text:title	
				},
				xAxis : [
			        {
			            data : xdata
			        }
			    ],
			    series : [
			        {
			            data:vdata
			        }
			    ]
			})
			//把当前bar图条件记录下来
			GV.GroupBarQueryTerm=[groupid,groupdesc,startdate,enddate];
		})
	}
	$('#container').width(GV.maxWidth-10);
	var dom = document.getElementById("container");
	var myChart = echarts.init(dom);
	var option = {
		title:{
			text:'页面事件统计排名'
			,right:'4%'
		},
	    color: ['#3398DB'],
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
	        },
	        formatter:function(params){
		    	//console.log(params)  ;
		    	var param=params[0];
		    	var rtn=param.name+"<br>"+"总次数:"+param.data+"<br>"+param.marker+ GV.GroupBarData[param.dataIndex].detail.split(",").join("<br>"+param.marker);
		    	return rtn;
		    }
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: GV.maxWidth>1400?'3%':'8%',
	        containLabel: true
	    },
	    xAxis : [
	        {
	            type : 'category',
	            data : [],
	            axisTick: {
	                alignWithLabel: true
	            },
	            axisLabel: {  
				   interval:0,  
				   rotate:GV.maxWidth>1400?0:15
				}  
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value'
	        }
	    ],
	    series : [
	        {
	            name:'次数',
	            type:'bar',
	            barWidth: '60%',
	            data:[]
	        }
	    ]
	};
	myChart.setOption(option, true);
	myChart.on('click',function(o){
		//console.log(o);
		//GV.GroupBarQueryTerm=[groupid,groupdesc,startdate,enddate];
		var qt=GV.GroupBarQueryTerm;  //取到柱状图的查询条件
		//跳到页面详情界面,看详情
		GV.page_group_cbg.setText(qt[1]);
		GV.page_group_cbg.setValue(qt[0]);
		
		GV.page_cbg.setText(o.name);
		var page=GV.GroupBarData[o.dataIndex].page;
		GV.page_cbg.setValue(page);    //value 取page 不是pagedesc
		
		$('#page-startdate').datebox('setValue',qt[2]);
		$('#page-enddate').datebox('setValue',qt[3]);
		GV.page_logdetails.load({ClassName:'websys.LogClient',QueryName:'FindLogDetails',Page:page,StartDate:qt[2],EndDate:qt[3],GroupID:qt[0]})
		$('#tabs').tabs('select',3);
	})
}
var initTabUser=function(){
	GV.user_cbg=$HUI.combogrid('#user-cbg',{
		width:200,
		disabled:false,
		delay: 500,
		panelWidth:340,
		panelHeight:340,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCMessageOrgMgr',QueryName:'LookUpUser',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'姓名',width:180},{field:'Code',title:'工号',width:130},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		onHidePanel:function(){
			loadUserLogonLog();
		},
		pagination:true//,
		//displayMsg:''
	});
	var pager=GV.user_cbg.grid().datagrid('getPager');
	pager.pagination('options').displayMsg="";
	
	GV.user_logonlog=$HUI.datagrid('#user-logonlog',{
		width:400,
		height:GV.maxHeight-110,
		mode: 'remote',
		queryParams:{ClassName:'websys.LogClient',QueryName:'FindUserLogonLog',UserID:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'logid',
		columns: [[{field:'logid',title:'id',hidden:true},{field:'date',title:'日期',width:98},{field:'time',title:'时间',width:75},{field:'loc',title:'科室',width:100},{field:'group',title:'安全组',width:100}]],
		pagination:true,
		pageSize:30,
		singleSelect:true,
		striped:true,
		onClickRow:function(index,row){
			if(row && row.logid && row.logid>0){
				debounce_showOneceLogonTimeLine(row.logid)
			}
		},
		onLoadSuccess:function(data){
			if(data.total>0 ){
				if(!GV.user_logonlog.getSelected()){
					GV.user_logonlog.selectRow(0);
					showOneceLogonTimeLine(data.rows[0].logid);
				}
			}else{
				if(GV.user_logonlog.options().queryParams["UserID"]>0){
					$('#LogonTimeLine').html("<li>未查询到用户登录记录,请修改查询条件</li>");
				}else{
					$('#LogonTimeLine').html("<li>请输入查询条件,查询用户登录记录</li>");
				}
			}

		}
	})
	var pager=GV.user_logonlog.getPager();
	pager.pagination('options').displayMsg="";
	$('#LogonTimeLineContainer').width(GV.maxWidth-400-40-10).height(GV.maxHeight-110);
	
	$('#user-ok').click(function(){
		loadUserLogonLog();
	})
	var showOneceLogonTimeLine=function(logid){
		$.cm({ClassName:'websys.LogClient',MethodName:'GetOnceLogonTimeLine',logid:logid},function(rtn){
			//console.log(rtn);
			/*$.each(rtn,function(i,e){
				$('#LogonTimeLine').append('<li><div class="circle"></div>'+e.date+' '+e.time+' <span class="desc">'+e.desc+'</span></li>');
			})*/
			if (rtn.length>0){
				$('#LogonTimeLine').html($('#TimeLineTmpl').tmpl(rtn));
			}else{
				$('#LogonTimeLine').html("<li>没有操作日志记录</li>");
			}
			
		})
	}
	$('#LogonTimeLine').on('click','.timeline-page',function(){
		if ($(this).children('.circle').hasClass('playcircle')){
			$(this).children('.circle').removeClass('playcircle');
			$(this).parent().find('.events').slideUp();
		}else{
			$(this).children('.circle').addClass('playcircle');
			$(this).parent().find('.events').slideDown();
		}
	})
	var debounce_showOneceLogonTimeLine=debounce(showOneceLogonTimeLine,500);  //延迟500ms加载时间线
	var loadUserLogonLog=function(){
		if(GV.user_cbg!=undefined){
			GV.user_logonlog.unselectAll();
			var val=GV.user_cbg.getValue();
			var text=GV.user_cbg.getText();
			var startdate=$('#user-startdate').datebox('getValue');
			var now=new Date();
			if (startdate=="") {
				startdate=$.fn.datebox.defaults.formatter(now);
				$('#user-startdate').datebox('setValue',startdate);
			}
			var enddate=$('#user-enddate').datebox('getValue');
			if (enddate=="") {
				enddate=$.fn.datebox.defaults.formatter(now);
				$('#user-enddate').datebox('setValue',enddate);
			}
			if (val>0) {
				GV.user_logonlog.load({ClassName:'websys.LogClient',QueryName:'FindUserLogonLog',UserID:val,StartDate:startdate,EndDate:enddate})
			}
		}
	}
}
var initTabPage=function(){
	GV.page_group_cbg=$HUI.combogrid('#page-group-cbg',{
		width:200,
		disabled:false,
		delay: 500,
		panelWidth:320,
		panelHeight:340,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCMessageOrgMgr',QueryName:'LookUpGroup',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'安全组',width:300},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});
	GV.page_cbg=$HUI.combogrid('#page-cbg',{
		width:200,
		disabled:false,
		delay: 500,
		panelWidth:410,
		panelHeight:340,
		mode: 'remote',
		queryParams:{ClassName:'websys.LogClient',QueryName:'LookUpLogPage',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'page',
		textField: 'pagedesc',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'page',title:'页面',width:190},{field:'pagedesc',title:'页面描述',width:190}]],
		pagination:true
	});
	var pager=GV.page_cbg.grid().datagrid('getPager');
	pager.pagination('options').displayMsg="";
	
	GV.page_logdetails=$HUI.datagrid('#page-logdetails',{
		width:GV.maxWidth-20,
		height:GV.maxHeight-110,
		mode: 'remote',
		queryParams:{ClassName:'websys.LogClient',QueryName:'FindLogDetails',Page:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'logcid',
		//logcid,date,time,page,pagedesc,rule,srcEle,srcVal,other,user,loc,group
		columns: [[
			{field:'logcid',title:'id',hidden:true},{field:'date',title:'日期'},{field:'time',title:'时间'},
			{field:'page',title:'页面'},{field:'pagedesc',title:'页面描述'},
			{field:'rule',title:'事件'},{field:'srcEle',title:'事件源'},{field:'srcVal',title:'事件源值'},{field:'other',title:'其它'},
			{field:'user',title:'用户'},{field:'loc',title:'科室'},{field:'group',title:'安全组'}
		]],
		pagination:true,
		pageSize:30,
		singleSelect:true,
		striped:true,
		fitColumns:true
	});
	$('#page-ok').click(function(){
		loadPageLogDetails();
	})
	var loadPageLogDetails=function(){
		if(GV.page_cbg!=undefined){
			var val=GV.page_cbg.getValue();
			var text=GV.page_cbg.getText();
			var startdate=$('#page-startdate').datebox('getValue');
			var now=new Date();
			if (startdate=="") {
				startdate=$.fn.datebox.defaults.formatter(now);
				$('#page-startdate').datebox('setValue',startdate);
			}
			var enddate=$('#page-enddate').datebox('getValue');
			if (enddate=="") {
				enddate=$.fn.datebox.defaults.formatter(now);
				$('#page-enddate').datebox('setValue',enddate);
			}
			var group="";
			if(GV.page_group_cbg!=undefined){
				group=GV.page_group_cbg.getValue();
			}
			if (val!="") {
				GV.page_logdetails.load({ClassName:'websys.LogClient',QueryName:'FindLogDetails',Page:val,StartDate:startdate,EndDate:enddate,GroupID:group>0?group:""})
			}
		}
	}
}
$(init)