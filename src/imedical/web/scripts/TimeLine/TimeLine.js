var GV={};
GV.dayWidth=160;
GV.minWidth=1310;
GV.commonCfg={
	
}


///把配置数据转成 适用的样子
function transConfig(){
	var LineConfig={  //长嘱配置
		colors:['#a2d7f0','#ffafaf','#89ffb5','#ffe775']	
	};
	var linkSize={  //报告打开大小
			'default':{width:1000,height:450},
			'0101':{width:1200,height:450},  //诊断
			'0306':{width:1200,height:310},  //血压
			'0401':{width:1000,height:'auto',maxHeight:'750'},  //检查
			'0501':{width:1000,height:450},  //检验
			'2001':{width:1000,height:'auto',maxHeight:'750'},  //病理
			'2101':{width:1000,height:450},  //心电
			'0901':{width:1200,height:550},  //病历文书
			'1901':{width:1200,height:550},  //过敏
			'1301':{width:920,height:'auto',maxHeight:'750'} , //会诊记录
			'1501':{width:900,height:'auto',maxHeight:'600'}
		};
	var headerLink={  //头链接 如血压
		'0306':'timeline.csp?OneItem=BloodPressure',
		'1901':'dhcdoc.allergyenter.csp?a=a'
	};
	var headerSetting=['0601','1701'];
	
    var CurveConfig={
        lines:{
        	'0202':{
	            start:10,
	            step:10,
	            color:'#F3A02E'
	        },
	        '0203':{
	            start:50,
	            step:20,
	            color:'#EA5252'
	        },
	        '0204':{
	            start:35,
	            step:1,
	            color:'#2E8CB9'
	        },
	        'default':{
	            start:10,
	            step:30,
	            color:'#2E8CB9'
	        },
	        '03061':{
	            start:60,
	            step:20,
	            color:'#D51616'
	        },
	        '03062':{
	            start:60,
	            step:20,
	            color:'#5AAD22'
	        }
        },
        stepHeight:25,
        stepCount:6
	}
	var orderViewConfig={};
	orderViewConfig.ordIdCommFormatter=function(id,item){
		var idarr=id.split('||');
		return parseInt(idarr[0])+'||'+ parseInt(idarr[1]);
	}
	orderViewConfig['0601']={ //长期药品
		isOrderView:true,
		ordIdKey:'objId',
		ordIdKeyFormatter:orderViewConfig.ordIdCommFormatter,
		ordViewType:'DRUG',
		ordViewBizIdKey:''
	}
	orderViewConfig['0701']={ //临时药品
		isOrderView:true,
		ordIdKey:'Parameters',
		ordIdKeyFormatter:orderViewConfig.ordIdCommFormatter,
		ordViewType:'DRUG',
		ordViewBizIdKey:''
	}
	orderViewConfig['1501']={ //处方
		isOrderView:true,
		ordIdKey:'DataValue',
		ordViewType:'DRUG',
		ordViewBizIdKey:''
	}
	orderViewConfig['0801']={ //手术
		isOrderView:true,
		ordIdKey:'DataValue',
		ordViewType:'AN',
		ordViewBizIdKey:''
	}
	orderViewConfig['0401']={ //检查
		isOrderView:true,
		ordIdKey:'ObjectID',
		ordIdKeyFormatter:orderViewConfig.ordIdCommFormatter,
		ordViewType:'MT',
		ordViewBizIdKey:''
	}
	orderViewConfig['0501']=$.extend({},orderViewConfig['0401'],{}); //检验
	orderViewConfig['2001']=$.extend({},orderViewConfig['0401'],{}); //病理
	orderViewConfig['2101']=$.extend({},orderViewConfig['0401'],{}); //心电
	
	orderViewConfig['2201']={ //输血
		isOrderView:true,
		ordIdKey:'ObjectID',
		ordIdKeyFormatter:orderViewConfig.ordIdCommFormatter,
		ordViewType:'BLD',
		ordViewBizIdKey:''
	}
	
	orderViewConfig['2301']={ //危急值
		isOrderView:true,
		ordIdKey:'DataValue',
		ordIdKeyFormatter:orderViewConfig.ordIdCommFormatter,
		ordViewType:'CV',
		ordViewBizIdKey:'ObjectID'
	}
	
	
    var config=[];var temp={};configIndex={};
    for (var i=0 ;i<CategroyData.CategroyConfig.length;i++){
	    var item=CategroyData.CategroyConfig[i];   
	    if (item.CategroyCode=="15") item.ViewType="P";  //处方 把类型改成P Part  
	    configIndex[item.DataTypeCode]=item;  //用代码作为key值 
	    if (item.ViewType=="C"){
			if (typeof temp[item.CategroyCode+"xx"]=="undefined"){
				config.push({code:item.CategroyCode+"xx",text:item.CategroyDesc,type:item.ViewType,parameters:item.Parameters});
				temp[item.CategroyCode+"xx"]={
					stepHeight:CurveConfig.stepHeight,
					stepCount:CurveConfig.stepCount,
					lines:[
						$.extend({}, CurveConfig.lines[item.DataTypeCode]||CurveConfig.lines["default"],{text:item.DataTypeDesc,DataTypeCode:item.DataTypeCode})
					]
				}
			}else{
				temp[item.CategroyCode+"xx"].lines.push( $.extend({}, CurveConfig.lines[item.DataTypeCode]||CurveConfig.lines["default"],{text:item.DataTypeDesc,DataTypeCode:item.DataTypeCode}) );
			}
		}else{
			config.push({code:item.DataTypeCode,text:item.DataTypeDesc,type:item.ViewType,parameters:item.Parameters,headerLink:headerLink[item.DataTypeCode]||'',headerSetting:headerSetting.indexOf(item.DataTypeCode)>-1});
		}
	}
	GV.DataConfig={
		common:config,  //每一行的
		curve:temp,   //单独对是折线图的配置,
		index:configIndex   //将
		,line:LineConfig  //长嘱配置,
		,showDrugNames:[]
		,showDepartNames:[],
		linkSize:linkSize,
		headerLink:headerLink,
		headerSetting:headerSetting
		,orderViewConfig:orderViewConfig
	}
	if (typeof sessionShowDepart=="string"&&sessionShowDepart!="") GV.DataConfig.showDepartNames=sessionShowDepart.split("|");
	//console.log(GV.DataConfig);
}
function getLinkSize(DataTypeCode){
	var oneLinkSize=GV.DataConfig.linkSize[DataTypeCode]||GV.DataConfig.linkSize['default'];
	var envMaxHeight=$(window).height()-20;
	var envMaxWidth=$(window).width()-20;
	var cfgMaxHeight=oneLinkSize.maxHeight||10000;
	var cfgMaxWidth=oneLinkSize.maxWidth||10000;
	var maxHeight=Math.min(envMaxHeight,cfgMaxHeight);
	var maxWidth=Math.min(envMaxWidth,cfgMaxWidth);
	var height=oneLinkSize.height||"auto";
	if (height=="auto") height=maxHeight;
	height=Math.min(maxHeight,height);
	var width=oneLinkSize.width||"auto";
	if (width=="auto") width=maxWidth;
	width=Math.min(maxWidth,width);
	return {width:width,height:height};
}
///把数据转成ClinicData
function transData2ClinicalData(data){
	if (OneItem=="Diagnose"){
		var temp={};
		var showDateList=[];
		$.each(data.Data,function(){
			if(showDateList.indexOf(this.ActDate)==-1) showDateList.push(this.ActDate);
			var act=this.ObjectID.split("||")[0];
			if (temp["0101"+act]){
				temp["0101"+act].records.push(this);
			}else{
				temp["0101"+act]={
					CategroyCode:"0101",
					DataTypeCode:"0101"+act,
					records:[this]
				}
			}
		})
		window.ClinicalData={
			PatientInfo:data.PatientInfo,
			DataArray:[],
			showDateList:showDateList
		}
		$.each(temp,function(){
			ClinicalData.DataArray.push(this);
		})
	}else if(OneItem=="BloodPressure"){
		var temp={};
		$.each(data.DataArray,function(){
			var pressure1=this.DataValue.split('/')[0]; //收缩压
			var pressure2=this.DataValue.split('/')[1]; //舒张压
			var r1=$.extend({},this,{DataValue:pressure1});
			var r2=$.extend({},this,{DataValue:pressure2});
			if (temp["03061"]){
				temp["03061"].records.push(r1);
			}else{
				temp["03061"]={
					CategroyCode:"0306",
					DataTypeCode:"03061",
					records:[r1]
				}
			}
			if (temp["03062"]){
				temp["03062"].records.push(r2);
			}else{
				temp["03062"]={
					CategroyCode:"0306",
					DataTypeCode:"03062",
					records:[r2]
				}
			}
		})
		window.ClinicalData=$.extend({searchDate:queryDate},data,{DataArray:[]});
		$.each(temp,function(){
			ClinicalData.DataArray.push(this);
		})
	}
}
function transConfig2CategroyData(config){
	if (OneItem=="Diagnose"){
		window.CategroyData={CategroyConfig:[]};
		$.each(config,function(){
			var t={
				CategroyCode:"0101",
				CategroyDesc:"诊断记录",
				DataTypeCode:"0101"+this.ObjectID,
				DataTypeDesc:this.Description,
				Parameters:"",
				ViewType:"L"
			}
			CategroyData.CategroyConfig.push(t);
		})
	}else if(OneItem=="BloodPressure"){
		window.CategroyData={CategroyConfig:[
			{
				CategroyCode:"0306",
				CategroyDesc:"血压",
				DataTypeCode:"03061",
				DataTypeDesc:"收缩压",
				Parameters:"",
				ViewType:"C"
			},{
				CategroyCode:"0306",
				CategroyDesc:"血压",
				DataTypeCode:"03062",
				DataTypeDesc:"舒张压",
				Parameters:"",
				ViewType:"C"
			}
		]};
	}
}


/*根据配置数据先把网格生成出来*/
function initGrid(){
	
    $('#rowHeaderTmpl').tmpl(GV.DataConfig.common).appendTo('#left>.tl-grid-body>.tl-grid-body-inner');	
    var rowTime={dates:[{text:""},{text:""},{text:""},{text:""},{text:""},{text:""},{text:""}]};
    $('#timeGridTmpl').tmpl(rowTime).appendTo('#right>.tl-grid-header');
    $('#rowDataTmpl').tmpl(GV.DataConfig.common).appendTo('#right>.tl-grid-body>.tl-grid-body-inner');
    //给左右最后一行加上last类
    $('.tl-grid-body>.tl-grid-body-inner').find('.tl-row-header:last,.tl-row-header-collapsed:last,.tl-row-data:last,.tl-row-data-collapsed:last').addClass('last');
    
    $.each(GV.DataConfig.curve,function(i){
	    var headerDom=$('#left').find('.tl-row-header[data-for="'+i+'"]')[0];
	    fillCurveHeader(headerDom,this);
	});
	//折叠事件
	$('.tl-row-header .collapse').click(function(){
		var row_header=$(this).closest('.tl-row-header');
		var DataTypeCode=row_header.data('for');
		$('.tl-row-header-collapsed[data-for="'+DataTypeCode+'"]').removeClass('hidden');
		$('.tl-row-data-collapsed[data-for="'+DataTypeCode+'"]').removeClass('hidden');
		$('.tl-row-data[data-for="'+DataTypeCode+'"]').addClass('hidden');
		row_header.addClass('hidden');
		debounce_fixGridBodyScroll();
	})
	$('.tl-row-header-collapsed .expand').click(function(){
		var row_header_collapsed=$(this).closest('.tl-row-header-collapsed');
		var DataTypeCode=row_header_collapsed.data('for');
		
		$('.tl-row-header[data-for="'+DataTypeCode+'"]').removeClass('hidden');
		$('.tl-row-data[data-for="'+DataTypeCode+'"]').removeClass('hidden');
		
		$('.tl-row-data-collapsed[data-for="'+DataTypeCode+'"]').addClass('hidden');
		row_header_collapsed.addClass('hidden');
		debounce_fixGridBodyScroll();
	})
	
	//itemLabelWithLink 点击事件
	$('#center').off('click.itemlabel').on('click.itemlabel','.tl-itemLabel-withLink .tl-itemLabel-text,.tl-itemLabel-multiple .tl-itemLabel-text-c',function(){
		var linkPath=$(this).closest('.tl-itemLabel-withLink,.tl-itemLabel-multiple').data('linkPath');
		var datatype=$(this).closest('.tl-row-data').data('for');
		
		
		var linkPathArr=linkPath.split('$$$');
		var finalLinkPath=$.grep(linkPathArr,function(iLinkPath){
			return !(iLinkPath=="" || /^[\u4e00-\u9fa5]/.test(iLinkPath));
		})
		
		if (finalLinkPath.length==0){
			$.messager.popover({msg: '未出报告',type:'alert'});
		}else{
			var title=GV.DataConfig.index[datatype].DataTypeDesc;
			var cfg={title:title};
			$.extend(cfg,getLinkSize(datatype));
			showReportWin(finalLinkPath,cfg);
		}
	})
	
	
	//tl-rowHeader 上的设置  如长期药品
	$('#center').off('click.rowHeaderSettings').on('click.rowHeaderSettings','.tl-row-header .settings',function(){
		var datatype=$(this).closest('.tl-row-header').data('for');
		if (datatype=="0601"){
			//##Class(icare.TimeLineView).GetDrugCatogry(episodeId)
			$m({
				ClassName:'icare.web.TimeLineData'	,
				MethodName:'GetDrugCatogry',
				wantreturnval:1,
				EpisodeID:episodeId
			},function(res){
				if(res==""){
					$.messager.popover({msg:'此次就诊没有长期药品医嘱不需要设置',type:'alert'})	;
					return ;
				}
				var allDrugArr=res.split(',');
				var temp={cols:3,list:[]};
				$.each(allDrugArr,function(idx,value){
					temp.list.push({text:value,
									value:value,
									checked:(GV.DataConfig.showDrugNames.length==0||GV.DataConfig.showDrugNames.indexOf(value)>-1)
								});
				})
				showCkTableWin(temp,{title:'设定药品显示项',width:600});
			})
		}else if (datatype=="1701"){ //门诊就诊信息
			$m({
				ClassName:'icare.web.TimeLineData'	,
				MethodName:'GetDepartmentNames',
				wantreturnval:1,
				PatientID:patientID
			},function(res){
				if(res==""){
					$.messager.popover({msg:'未获取到就诊科室记录',type:'alert'})	;
					return ;
				}
				var allDrugArr=res.split('|');
				var temp={cols:3,list:[]};
				$.each(allDrugArr,function(idx,value){
					temp.list.push({text:value,
									value:value,
									checked:(GV.DataConfig.showDepartNames.length==0||GV.DataConfig.showDepartNames.indexOf(value)>-1)
								});
				})
				showCkTableWin(temp,{title:'设定显示科室',width:600});
			})
		}
	})
	//tl-rowHeader 链接 如血压
	$('#center').off('click.rowHeaderLink').on('click.rowHeaderLink','.tl-row-header .headerLink',function(){
		var datatype=$(this).closest('.tl-row-header').data('for');
		var title=GV.DataConfig.index[datatype].DataTypeDesc;
		var cfg={title:title};
		var linkPath=GV.DataConfig.headerLink[datatype];
		$.extend(cfg,getLinkSize(datatype));
		linkPath+=(linkPath.indexOf("?")>-1?'&':'?')+"EpisodeID=" + episodeId + "&PatientID=" + patientID;
		if (datatype=="0306"){
			linkPath+='&StartDate='+ClinicalData.searchDate||'';
		}
		showReportWin(linkPath,cfg);
	})
}
function showReportWin(url,cfg){
	if (typeof url=="string"){
		url=[url];
	}
	var width=cfg.width||1000,height=cfg.height||450;
	var $content=$('<div class="reportWinContent" data-selected="0"></div>');
	var $content_items=$('<div class="reportWinContent-items" style="width:'+width*url.length+'px;"></div>').appendTo($content);
	
	$.each(url,function(idx,oneurl){
		$content_items.append('<div class="reportWinContent-item" style="overflow:hidden;width:'+width+'px;height:'+(height-37)+'px;"><iframe scrolling="auto" frameborder=0 style="width:100%;height:100%;" src="'+oneurl+'"></iframe></div>')
	})
	$content_items.append('<div style="clear:both;"></div>');
	$content_prev=$('<div class="reportWinContent-prev hidden">&lt;</div>').appendTo($content);
	$content_next=$('<div class="reportWinContent-next hidden">&gt;</div>').appendTo($content);
	cfg=cfg||{};
	if (!GV.reportWin){
		GV.reportWin=$('<div id="reportWin" style="overflow:hidden;"></div>');
	}
	GV.reportWin.empty();
	$content.appendTo(GV.reportWin);
	if(url.length>1) $content_next.removeClass('hidden');
	
	$content_prev.off('click').on('click',function(){
		var $con=$(this).closest('.reportWinContent');
		var onewidth=$con.find('.reportWinContent-item').width();
		var selected=$con.data('selected');
		if(selected>0) {
			$con.data('selected',selected-1);
			$con.find('.reportWinContent-items').css('left',-onewidth*(selected-1));
			if (selected==1) $(this).addClass('hidden');
			$con.find('.reportWinContent-next').removeClass('hidden');
		}
	})
	
	$content_next.off('click').on('click',function(){
		var $con=$(this).closest('.reportWinContent');
		var onewidth=$con.find('.reportWinContent-item').width();
		var selected=$con.data('selected');
		var num=$con.find('.reportWinContent-item').length;
		if(selected<(num-1)) {
			$con.data('selected',selected+1);
			$con.find('.reportWinContent-items').css('left',-onewidth*(selected+1));
			if (selected==num-2) $(this).addClass('hidden');
			$con.find('.reportWinContent-prev').removeClass('hidden');
		}
	})
	
	
	
	GV.reportWin.dialog({
		iconCls:'icon-w-paper',
		modal:true,
		title:cfg.title||'报告',
		width:width,
		height:height
	}).dialog('open');
	
	$content_prev.cl
}

function ifShowDrug(DataValue){
	if (!GV.DataConfig.showDrugNames ||GV.DataConfig.showDrugNames.length==0) return true;
	var flag=false;
	$.each(GV.DataConfig.showDrugNames,function(){
		if(DataValue.indexOf(this)>-1) {
			flag=true	;return false;
		}
	})
	return flag;
}
function getLongDrugHover(r){
	var o=$.extend({},r);
	var match=o.DataValue.match(/\[(.+)\]/);
	var title="";
	if (match){
		var names=match[1].split(',');
		var titleArr=[],specificationArr=[];
		$.each(names,function(i,v){
			titleArr.push(v.split(' ')[0]);
			specificationArr.push(v.split(' ')[1]);
		})
		title=titleArr.join(',');
		o.specification=specificationArr.join(',')
		o.usage=o.DataValue.replace(/\[(.+)\]/,'').split(' ')[2];
	}else{
		var arr=o.DataValue.split(" ");
		o.specification=arr[1];
		o.usage=arr[3];
		title=arr[0];
	}

	o.startDate=websys_formatDate(o.startDate);
	o.endDate=websys_formatDate(o.endDate);
	return {title:title,html:$('#itemLineHoverTmpl').tmpl(o).prop('outerHTML')};
}
/*根据数据填信息*/
function fillData(){ 
	if (OneItem=="Diagnose"){
		$('#right .tl-row-data.tl-row-timer').find('.tl-row-data-cell').each(function(i){
			if (ClinicalData.showDateList[i]) {
				$(this).find('.th1').text( getDateTextArray(ClinicalData.showDateList[i],1)[0]);
			}else{
				$(this).find('.th1').text("");
			}
		})
	}else if (timeLineId=="OutpatientView"){
		//门诊是按就诊id来排列
		var showEpisodeList=[];
		if(ClinicalData.queryEpisodelst!=""){
			var showEpisodeList=ClinicalData.queryEpisodelst.split("|");
		}
		GV.showEpisodeList=showEpisodeList;  //门诊集成视图 当前页显示的就诊记录
		
		$('#right .tl-row-data.tl-row-timer').find('.tl-row-data-cell').each(function(i){
			if (showEpisodeList[i]) {
				$(this).find('.th1').text( GetDateAndWeekDayHour(showEpisodeList[i]));
			}else{
				$(this).find('.th1').text("");
			}
			
		})
		
		 
	}else{
		//填充日期
		var searchDate=ClinicalData.searchDate;
		var dateTextArray=getDateTextArray(searchDate,Math.min(7,calDays(searchDate,ClinicalData.EndDate)+1));
		$('#right .tl-row-data.tl-row-timer').find('.tl-row-data-cell').each(function(i){
			$(this).find('.th1').text( dateTextArray[i]||"");
		})
	}

	
	
    $.each(GV.DataConfig.curve,function(i){
	    var dataDom=$('#right').find('.tl-row-data[data-for="'+i+'"]>.c')[0];
	    fillCurveBody(dataDom,this,ClinicalData);
	})
	
	///循环遍历数据 往表格中填充
	$.each(ClinicalData.DataArray,function(){
		var t=this;
		var DataTypeCode=t.DataTypeCode;
		var thisCfg=GV.DataConfig.index[DataTypeCode];
		var ViewType=thisCfg.ViewType;
		if (ViewType=="C" ) {
			return true;
		}else if (ViewType=="N"){//长期药品
			//
			$.each(t.records,function(idx){
				var item=this;
				if(!ifShowDrug(item.DataValue)) return true;
				var o={text:item.DataValue};
				if (calDays(searchDate,item.startDate)>=0){  //开始日期在 显示出首日内
					//计算left位置
					o.left=$zth(item.startTime)/86400*GV.dayWidth+calDays(searchDate,item.startDate)*GV.dayWidth;
					o.left=Math.floor(o.left);
					o.left=o.left-19;
					o.left<0?o.left=0:'';
					o.showStart=true;
				}else{
					o.left=0;
					o.showStart=false;
				}
				var maxDate=moveDay(searchDate,6); //当前格子最后一天
				if (calDays(maxDate,ClinicalData.EndDate)<0){  //所有数据最后一天 小于当前格子最后一天
					maxDate=ClinicalData.EndDate;
				}
				
				if (item.endDate=="" || calDays(maxDate,item.endDate)>0 ){  //结束日期为空  结束日期在最大格子之后
					var right=(calDays(searchDate,maxDate)+1)*GV.dayWidth;
					o.width=right-o.left;
					o.showEnd=false;
				}else{
					var right=$zth(item.endTime)/86400*GV.dayWidth+calDays(searchDate,item.endDate)*GV.dayWidth;
					o.width=right-o.left;
					o.showEnd=true;
				}
				o.bgcolor=GV.DataConfig.line.colors[idx%GV.DataConfig.line.colors.length];


				if (GV.DataConfig.orderViewConfig && GV.DataConfig.orderViewConfig[DataTypeCode] ){
					var orderViewCfg=GV.DataConfig.orderViewConfig[DataTypeCode];
					if (orderViewCfg.isOrderView) {
						o.isOrderViewTrigger=true;
						o.ordId=item[orderViewCfg.ordIdKey]||'';
						if (orderViewCfg.ordIdKeyFormatter) o.ordId=orderViewCfg.ordIdKeyFormatter(o.ordId,item);
						o.ordViewType=orderViewCfg.ordViewType;
						o.ordViewBizId=item[orderViewCfg.ordViewBizIdKey||'']||'';
					}
				}

				//console.log(o)
				/*
				var ordArr=item.objId.split("||");
				o.isOrderViewTrigger=true,o.ordId=ordArr[0]+'||'+parseInt( ordArr[1] );*/



				
				
				var j=$('#itemLineTmpl').tmpl(o).appendTo( $('#right').find('.tl-row-data[data-for="'+DataTypeCode+'"]>.c')  );
				var obj=getLongDrugHover(item);
				j.find('.tl-itemLine-bg').popover({
					title:obj.title,
					trigger:'hover',
					content:obj.html,
					placement:(GV.dayWidth*7)-o.left>300?'top-right':'auto-left'
				})
			})

		}else {
			var jObjList=$('#right').find('.tl-row-data[data-for="'+DataTypeCode+'"] .tl-row-data-cell .c');
			$.each(t.records,function(){
				var item=this;
				if (OneItem=="Diagnose"){
					var index=ClinicalData.showDateList.indexOf(item.ActDate);
				}else if (timeLineId=="OutpatientView"){
					var index=GV.showEpisodeList.indexOf(item.EpisodeID);
				}else{
					var index=calDays(searchDate,item.ActDate);
				}
				if (ViewType=="T"){
					var subIndex=Math.floor($zth(item.ActTime)/86400*6);
					var text=item.DataValue;
					if (jObjList.eq(index).find('.tl-itemTable').length==0){
						$('#itemTableTmpl').tmpl({}).appendTo( jObjList.eq(index)  );
					}
					jObjList.eq(index).find('.tl-itemTable').find('td').eq(subIndex).append('<span>'+text+'</span>');
				}else if(ViewType=="P"){ //处方的
					var left=$zth(item.ActTime)/86400*GV.dayWidth;
	          		left=Math.min(GV.dayWidth-13,left);
	          		var linkPath=thisCfg.Parameters;
					if (linkPath!=""){
						if (item.Parameters!="") linkPath+=(linkPath.indexOf('?')>-1?"&":"?")+item.Parameters;
					}else{
						linkPath=item.Parameters
					}
					var o={
						left:left,
						texts:item.Summary.split('|').slice(0,4),//最多只保留4个
						linkPath:linkPath
					};
					if (GV.DataConfig.orderViewConfig && GV.DataConfig.orderViewConfig[DataTypeCode] ){
						var orderViewCfg=GV.DataConfig.orderViewConfig[DataTypeCode];
						if (orderViewCfg.isOrderView) {
							o.isOrderViewTrigger=true;
							o.ordId=item[orderViewCfg.ordIdKey]||'';
							if (orderViewCfg.ordIdKeyFormatter) o.ordId=orderViewCfg.ordIdKeyFormatter(o.ordId,item);
							o.ordViewType=orderViewCfg.ordViewType;
							o.ordViewBizId=item[orderViewCfg.ordViewBizIdKey||'']||'';
						}
					}
					/*
					o.isOrderViewTrigger=true,o.ordId=item.DataValue; //处方
					*/
					
					var j=$('#itemLabelMultipleTmpl').tmpl(o).appendTo( jObjList.eq(index)  );
					j.find('.tl-itemLabel-text-c').popover({
						content:item.Summary.split('|').join('<br>'),
						trigger:'hover'	
					})
				}else{
	          		var left=$zth(item.ActTime)/86400*GV.dayWidth;
	          		left=Math.min(GV.dayWidth-13,left);
					var o={
						text:item.Summary||item.ActTime,
						left:left,
					};
					
					if (GV.DataConfig.orderViewConfig && GV.DataConfig.orderViewConfig[DataTypeCode] ){
						var orderViewCfg=GV.DataConfig.orderViewConfig[DataTypeCode];
						if (orderViewCfg.isOrderView) {
							o.isOrderViewTrigger=true;
							o.ordId=item[orderViewCfg.ordIdKey]||'';
							if (orderViewCfg.ordIdKeyFormatter) o.ordId=orderViewCfg.ordIdKeyFormatter(o.ordId,item);
							o.ordViewType=orderViewCfg.ordViewType;
							o.ordViewBizId=item[orderViewCfg.ordViewBizIdKey||'']||'';
						}
					}

					/*if(DataTypeCode=="0701"){ //临时药品
						var ordArr=item.Parameters.split("||");
						o.isOrderViewTrigger=true,o.ordId=ordArr[0]+'||'+parseInt( ordArr[1] );
					}
					if(DataTypeCode=="0801"){ //手术
						var ordArr=item.DataValue.split("||");
						if (ordArr[0]>0 && ordArr[1]>0){
							o.isOrderViewTrigger=true,o.ordId=ordArr[0]+'||'+parseInt( ordArr[1] );
						}
					}
					if(DataTypeCode=="0401" || DataTypeCode=="0501" || DataTypeCode=="2001" ||DataTypeCode=="2101"){
						var ordArr=item.ObjectID.split("||");
						o.isOrderViewTrigger=true,o.ordId=ordArr[0]+'||'+parseInt( ordArr[1] );
					}*/
					
					
					if (OneItem=="Diagnose"){
						var j=$('#itemLabelNoArrowTmpl').tmpl(o).appendTo( jObjList.eq(index)  );
						j.find('.tl-itemLabel-text').popover({
							content:o.text,
							trigger:'hover'	
						})
					}else if (ViewType=="L" ){
						var j=$('#itemLabelTmpl').tmpl(o).appendTo( jObjList.eq(index)  );
						j.find('.tl-itemLabel-text').popover({
							content:o.text,
							trigger:'hover'	
						})
					}else if (ViewType=="A"){
						var linkPath=thisCfg.Parameters;
						if (linkPath!=""){
							if (item.Parameters!="") {
								var parameterArr=item.Parameters.split('$$$');
								$.each(parameterArr,function(ind){
									parameterArr[ind]=linkPath+(linkPath.indexOf('?')>-1?"&":"?")+parameterArr[ind];
								})
								linkPath=parameterArr.join('$$$');
							}
						}else{
							linkPath=item.Parameters
						}
						
						if (DataTypeCode=="0101"){ //诊断后台没拼
							linkPath+=(linkPath.indexOf("?")>-1?'&':'?')+"EpisodeID=" + episodeId + "&PatientID=" + patientID;
						}
						o.widthLink=true;
						o.linkPath=linkPath;
						var j=$('#itemLabelWithLinkTmpl').tmpl(o).appendTo( jObjList.eq(index)  );
						j.find('.tl-itemLabel-text').popover({
							content:o.text,
							trigger:'hover'	
						})
					}
				}
			})
		} 
	})
	
	
	if (ClinicalData && ClinicalData.PatientInfo && typeof ClinicalData.PatientInfo.allergyCount=='string' ){
		var sp=$('.tl-row-header[data-for="1901"]').find('.title');
		if (ClinicalData.PatientInfo.allergyCount>0) {
			sp.addClass('headerLink headerWithCount');
			sp.append('<span class="count">'+ClinicalData.PatientInfo.allergyCount+'</span>');
		}else{
			sp.removeClass('headerLink headerWithCount');
			sp.find('.count').remove();
		}
	}
	
	
	
	//内容撑起右侧高度  要修改左侧高度
	
	$('#right').find('.tl-row-data').each(function(){
		//console.log($(this).height());
		var datatype=$(this).data('for');
		$('#left').find('.tl-row-header[data-for="'+datatype+'"]').height( $(this).height());
	})
	debounce_fixGridBodyScroll();
	$('.orderview-trigger').orderview({
		ordGetter:function(){
			return $(this).data('ord');	
		},
		trigger:'contextmenu',
		autoHeight:false
		,winHeight:600
	})
	
}
function reFillLongDrugData(){
	var searchDate=ClinicalData.searchDate;
	$('#right').find('.tl-row-data[data-for="0601"]>.c').empty();
	///循环遍历数据 往表格中填充
	$.each(ClinicalData.DataArray,function(){
		var t=this;
		var DataTypeCode=t.DataTypeCode;
		var thisCfg=GV.DataConfig.index[DataTypeCode];
		var ViewType=thisCfg.ViewType;
		
		if (ViewType=="N" && DataTypeCode=="0601"){//长期药品
			$.each(t.records,function(idx){
				var item=this;
				if(!ifShowDrug(item.DataValue)) return true;
				
				var o={text:item.DataValue};
				if (calDays(searchDate,item.startDate)>=0){  //开始日期在 显示出首日内
					//计算left位置
					o.left=$zth(item.startTime)/86400*GV.dayWidth+calDays(searchDate,item.startDate)*GV.dayWidth;
					o.left=Math.floor(o.left);
					o.left=o.left-19;
					o.left<0?o.left=0:'';
					o.showStart=true;
				}else{
					o.left=0;
					o.showStart=false;
				}
				var maxDate=moveDay(searchDate,6); //当前格子最后一天
				if (calDays(maxDate,ClinicalData.EndDate)<0){  //所有数据最后一天 小于当前格子最后一天
					maxDate=ClinicalData.EndDate;
				}
				
				if (item.endDate=="" || calDays(maxDate,item.endDate)>0 ){  //结束日期为空  结束日期在最大格子之后
					var right=(calDays(searchDate,maxDate)+1)*GV.dayWidth;
					o.width=right-o.left;
					o.showEnd=false;
				}else{
					var right=$zth(item.endTime)/86400*GV.dayWidth+calDays(searchDate,item.endDate)*GV.dayWidth;
					o.width=right-o.left;
					o.showEnd=true;
				}
				o.bgcolor=GV.DataConfig.line.colors[idx%GV.DataConfig.line.colors.length];
				//console.log(o)
				if (GV.DataConfig.orderViewConfig && GV.DataConfig.orderViewConfig[DataTypeCode] ){
					var orderViewCfg=GV.DataConfig.orderViewConfig[DataTypeCode];
					if (orderViewCfg.isOrderView) {
						o.isOrderViewTrigger=true;
						o.ordId=item[orderViewCfg.ordIdKey]||'';
						if (orderViewCfg.ordIdKeyFormatter) o.ordId=orderViewCfg.ordIdKeyFormatter(o.ordId,item);
						o.ordViewType=orderViewCfg.ordViewType;
						o.ordViewBizId=item[orderViewCfg.ordViewBizIdKey||'']||'';
					}
				}
				/*		
				var ordArr=item.objId.split("||");
				o.isOrderViewTrigger=true,o.ordId=ordArr[0]+'||'+parseInt( ordArr[1] );*/
				
				var j=$('#itemLineTmpl').tmpl(o).appendTo( $('#right').find('.tl-row-data[data-for="'+DataTypeCode+'"]>.c')  );
				var obj=getLongDrugHover(item);
				j.find('.tl-itemLine-bg').popover({
					title:obj.title,
					trigger:'hover',
					content:obj.html,
					placement:(GV.dayWidth*7)-o.left>300?'top-right':'auto-left'
				})
			})
		}
	})
	
	//内容撑起右侧高度  要修改左侧高度
	
	var H=$('#right').find('.tl-row-data[data-for="0601"]').height();
	$('#left').find('.tl-row-header[data-for="0601"]').height(H);
	debounce_fixGridBodyScroll();
	
	$('#right').find('.tl-row-data[data-for="0601"] .orderview-trigger').orderview({
		ordGetter:function(){
			return $(this).data('ord');	
		},
		trigger:'contextmenu',
		autoHeight:false
	})
	
}
function clearData(){
	$('#right').find('.tl-row-data .tl-row-data-cell .c').empty();
	$('#right').find('.tl-row-data >.c').empty();
}


function fillPatInfo(){
	if(!$('#top .tl-patInfo').is(':visible')) return;
	//病人信息
	var patInfo= ClinicalData.PatientInfo;
    patInfo.patIconCls=patInfo.sex=="男"?"sex-male":(patInfo.sex=="女"?"sex-female":"sex-unknown");
    patInfo.inDate=websys_formatDate(patInfo.inDate||''); //住院日期格式转换
    //console.log(patInfo);
    if (timeLineId=="OutpatientView"){
	    $('#patInfoOutTmpl').tmpl(patInfo).appendTo('#top .tl-patInfo');
	    
	}else{
		$('#patInfoTmpl').tmpl(patInfo).appendTo('#top .tl-patInfo');
	}
    
    
    //病人列表
    $m({
		ClassName:'icare.web.TimeLineData'	,
		MethodName:'GetLocDocPatient',
		wantreturnval:0,
		EpisodeID:episodeId
	},function(res){
		var LocDocPatientList=eval("("+res+")");
		//console.log('LocDocPatientList',LocDocPatientList);
		var currentAdmInPatientList=false;
		var currentAdmIndex=-1;
		$.each(LocDocPatientList.PatientList,function(idx){
			if (this.EpisodeID==episodeId) {
				currentAdmInPatientList=true;
				currentAdmIndex=idx;
				return false;
			}
		})
		if(!currentAdmInPatientList){
			//当前就诊不在查到的列表中
			var tempAdm={EpisodeID:episodeId,PatientID:patientID,PAPMIName:patInfo.name};
			LocDocPatientList.PatientList=[tempAdm].concat(LocDocPatientList.PatientList);
			currentAdmIndex=0;
		}
		var admSelector=$('#top .tl-patInfo').find('.tl-patInfo-Name').select2({
			textField:'PAPMIName',
			data:LocDocPatientList.PatientList,
			onChange:function(newv){
				//console.log(newv);
				//先尝试该变url的形式进行
				//此处先直接跳转timeline
				//location.href='/dthealth/web/csp/timeline.csp?'+'&PatientID='+newv.PatientID+'&EpisodeID='+newv.EpisodeID+'&mradm='+newv.mradm||'';
				location.href=rewriteUrl(location.href,{PatientID:newv.PatientID,EpisodeID:newv.EpisodeID,mradm:newv.mradm||''})
			}
		});
		var tempOnChange=admSelector.select2('options').onChange;
		admSelector.select2('options').onChange=function(){};
		admSelector.select2('select',currentAdmIndex);
		admSelector.select2('options').onChange=tempOnChange;
		
		
		
	})
}
function clearPatInfo(){
	$('#top .tl-patInfo').empty();
}
function fillAdmHistory(){
	if(!$('#top .tl-admHistory').is(':visible')) return;
    if (timeLineId=="OutpatientView"){
	    $('#top .tl-admHistory').hide();
	    return;
	}else{
		$('#top .tl-admHistory').show();
	}
    
    
    var activeIndex=0;var listStartIndex=0;
    $.each(SeeDoctorInfor,function(index){
		if (this.episodeId==episodeId) {
			activeIndex=index;
		}
		this.episodeDateTxt=websys_formatDate(this.episodeDate);
	})
	listStartIndex=Math.min(activeIndex,SeeDoctorInfor.length-4);
	listStartIndex<0?listStartIndex=0:'';
	
	var one_outerWidth=104;
	
    var admHistoryInfo={
	    title:timeLineId=="AdmView"?'历次住院记录':'历次住院、急诊留观记录',
	    admList:SeeDoctorInfor,
	    activeIndex:activeIndex,
	    listStartIndex:listStartIndex,
	    left:-listStartIndex*one_outerWidth,
	    one_outerWidth:one_outerWidth
	}
    $('#admHistoryTmpl').tmpl(admHistoryInfo).appendTo('#top .tl-admHistory');
    
    $('#top .tl-admHistory').on('click','.tl-admHistory-selector-list td span',function(){
	    if (!$(this).hasClass('active')){
			$('.tl-admHistory-selector-list td span.active').removeClass('active');
			$(this).addClass('active');
			//alert($(this).text()+','+$(this).data("adm"))
			//location.href='/dthealth/web/csp/timeline.csp?'+'&PatientID='+patientID+'&EpisodeID='+$(this).data("adm");
			location.href=rewriteUrl(location.href,{PatientID:patientID,EpisodeID:$(this).data("adm"),mradm:''})
		}
	})
	$('#top .tl-admHistory').on('click','.tl-admHistory-selector-prev',function(){
		if (!$(this).hasClass('disabled')){
			var selector=$(this).closest('.tl-admHistory-selector');
			var table=selector.find('.tl-admHistory-selector-list>table');
			var listStartIndex=table.data('listStartIndex');
			var listMaxIndex=table.data('listMaxIndex');
			if (listStartIndex>4){
				table.data('listStartIndex',listStartIndex-4).css('left',-(listStartIndex-4)*one_outerWidth);
				selector.find('.tl-admHistory-selector-next').removeClass('disabled');
			}else{
				
				table.data('listStartIndex',0).css('left',0);
				$(this).addClass('disabled');
				if (0<listMaxIndex) selector.find('.tl-admHistory-selector-next').removeClass('disabled');
			}
		}
	})
	$('#top .tl-admHistory').on('click','.tl-admHistory-selector-next',function(){
		//console.count(".tl-admHistory-selector-next");
		if (!$(this).hasClass('disabled')){
			var selector=$(this).closest('.tl-admHistory-selector');
			var table=selector.find('.tl-admHistory-selector-list>table');
			var listStartIndex=table.data('listStartIndex');
			var listMaxIndex=table.data('listMaxIndex');
			if (listStartIndex+4<listMaxIndex){
				table.data('listStartIndex',listStartIndex+4).css('left',-(listStartIndex+4)*one_outerWidth);
				selector.find('.tl-admHistory-selector-prev').removeClass('disabled');
			}else{
				table.data('listStartIndex',listMaxIndex).css('left',-listMaxIndex*one_outerWidth);
				$(this).addClass('disabled');
				if (0<listMaxIndex) selector.find('.tl-admHistory-selector-prev').removeClass('disabled');
			}
		}
	})
}
function clearAdmHistory(){
	$('#top .tl-admHistory').off('click').empty();;
}
function resizeHandler(){
    $('#left>.tl-grid-body>.tl-grid-body-inner').empty();	
    $('#right>.tl-grid-header').empty();	
    $('#right>.tl-grid-body>.tl-grid-body-inner').empty();
    calDayWidth();

	initGrid();
    fillData();
    fitBodySize();
}
function fitBodySize(){
	$('#center').height($(window).height()-$('#top').height()-10);
	$('#center').find('.tl-main-right .tl-grid-body').width(GV.dayWidth*7+20);
	$('#center').find('.tl-main-right .tl-grid-body>.tl-grid-body-inner').width(GV.dayWidth*7);
	//$('.tl-grid-body').height($(window).height()-$('#top').height()-65-10);
	$('.tl-grid-body').css('maxHeight',($(window).height()-$('#top').height()-65-10)+'px');
}
///有多处会使.tl-grid-body scroll状态改变
///1.填数据
///2 窗体大小改变  此时又调用了填数据 相当于1
///3 折叠部分
function fixGridBodyScroll(){
	var inner=$('.tl-main-right .tl-grid-body>.tl-grid-body-inner');
	var out=$('.tl-main-right .tl-grid-body');
	if (inner.height()>out.height()){
		out.width(GV.dayWidth*7+20);
	}else{
		out.width(GV.dayWidth*7+2);
	}
}
var debounce_fixGridBodyScroll=debounce(fixGridBodyScroll,200);
function calDayWidth(){
	var maxWidth=Math.max($(window).width(),GV.minWidth);
	//var tDayWidth=Math.floor((maxWidth-217-10-20-20)/7/5)*5;
	var tDayWidth=Math.floor((maxWidth-217-10-20-5)/7/1)*1;
	//tDayWidth=Math.min(tDayWidth,200);
	GV.dayWidth=tDayWidth;
}

var init=function(){


	if (OneItem=="Diagnose"){
		transData2ClinicalData(DiagnoseInfor);
		transConfig2CategroyData(DiagnoseType);
		GV.minWidth=1200;
	}else if(OneItem=="BloodPressure"){
		transData2ClinicalData(BloodPressureInfor);
		transConfig2CategroyData();
		GV.minWidth=1200;
		$('#top').empty();
		$('#top').height(10);
	}else{
		if (PageFrom==""){
			if((typeof outEpisodeID!="undefined" && outEpisodeID>0)||(typeof ClinicalData.inEpisodeID!="undefined" && ClinicalData.inEpisodeID>0)){
				GV.minWidth=1340;
			}
		}
	}

	$('body').css('minWidth',GV.minWidth+'px');
	calDayWidth();
	fitBodySize();
	$(window).resize(debounce(resizeHandler,200));
	$('.tl-main-right .tl-grid-body').scroll(function(){
		var scrollTop=$(this).scrollTop();
		$('.tl-main-left .tl-grid-body').scrollTop(scrollTop);
	})
	transConfig();
	initGrid();
	fillPatInfo();
    fillAdmHistory();
    fillData();
    if (OneItem=="Diagnose"){
		$('#weekSelector').arrayselector({
			tipText:'日期',
			data:(function(cnt){var arr=[];for(var i=0;i<cnt;i++){arr.push(i);} return arr;})(DiagnoseInfor.inforCount),
			currentIndex:0,
			onChange:function(newIndex){
				//console.log(newIndex);
				diagnose_changeDate(newIndex);
			}
		})
	}else if (timeLineId=="OutpatientView"){
		$('#weekSelector').arrayselector({
			data:ClinicalData.EpisodeList,
			onChange:function(newIndex){
				var EpisodeList=ClinicalData.EpisodeList,
					tempList=[],
					lstEpisodeId="";
				//console.log(ClinicalData.EpisodeList[newIndex]);

				for (var i=newIndex;i<EpisodeList.length&&i<newIndex+7;i++){
					tempList.push(EpisodeList[i].EpisodeID)
				}
				lstEpisodeId=tempList.join('|');
				//console.log(lstEpisodeId);
				out_changeDate(lstEpisodeId);
			}
		})
	}else{
	    $('#weekSelector').weekselector({
		    currentDate:ClinicalData.searchDate,
			startDate:ClinicalData.StartDate,
			endDate:ClinicalData.EndDate,
			weekMode:1,
			onChange:function(date){
				if (OneItem=="BloodPressure"){
					bloodPressure_changeDate(date);
				}else{
					changeDate(date);
				}
				
			}
		})
	}
	
	
	//设置显示项
	$('#top .tl-patInfo').off('click').on('click','.settings',function(){
		if (!GV.AllCategroyData){
			$m({
				ClassName:'icare.web.TimeLineData'	,
				MethodName:'GetTimeLineConfig',
				wantreturnval:0,
				SearchCode:"all",
				TimeLineId:timeLineId
			},function(res){
				var str=$(res).text();
				str=str.replace("var CategroyData =","GV.AllCategroyData=");
				GV.AllCategroyData=eval(str);
				//console.log(GV.AllCategroyData);
				showViewConfig();
			})
		}else{
			showViewConfig();
		}
	})
	//从住院打开门诊   从门诊打开住院  带个参数PageFrom ，否则互相打开，就成了套娃了，实际很有趣
	if (PageFrom==""&&typeof outEpisodeID!="undefined" && outEpisodeID>0){
		$('.tl-link .out-icon').closest('.tl-link').removeClass('hidden');
	}else{
		$('.tl-link .out-icon').closest('.tl-link').addClass('hidden');
	}
	if (PageFrom==""&&typeof ClinicalData.inEpisodeID!="undefined" && ClinicalData.inEpisodeID>0){
		$('.tl-link .in-icon').closest('.tl-link').removeClass('hidden');
	}else{
		$('.tl-link .in-icon').closest('.tl-link').addClass('hidden');
	}
	
	$('#top .tl-link').on('click',function(e){
		var icon=$(this).find('.tl-link-icon');
		if(icon.hasClass('out-icon')){
			SC_WinClose();
			var path = "timeline.csp?PatientID=" + patientID + "&EpisodeID=" + outEpisodeID + "&PageFrom="+timeLineId;
			//套娃窗口
			SC_CHILD_WINDOW=openRussianDollWin(path,{name:"out"+Math.random()});
    		//SC_CHILD_WINDOW = window.open(path, "门诊病情", "height=800, width=1370, statusbar=yes,scrollbars=yes,menubar=no,toolbar=no,resizable=yes,left=10,top=10");
		}
		if(icon.hasClass('in-icon')){
			SC_WinClose();
			var path = "timeline.csp?PatientID=" + patientID + "&EpisodeID=" + ClinicalData.inEpisodeID + "&PageFrom="+timeLineId;
			//套娃窗口
			SC_CHILD_WINDOW=openRussianDollWin(path,{name:"in"+Math.random()});
		}
		if(icon.hasClass('instructions-icon')){
			e.preventDefault();
			var url=$(this).attr('href');
			easyModal('使用说明',url,830,1000);

		}
	})
	window.onunload = SC_WinClose;
}
function SC_WinClose(){
	if(typeof SC_CHILD_WINDOW!="undefined" && SC_CHILD_WINDOW!=null){
		SC_CHILD_WINDOW.close();
		SC_CHILD_WINDOW=null;
	}
}

function showCkTableWin(data,cfg){
	
	if (!cfg.height||cfg.height=="auto"){
		var tableH=Math.ceil(data.list.length/data.cols)*30;
		cfg.height=tableH+(300-213)+20;
	}
	if (!GV.ckTableWin){
		GV.ckTableWin=$('<div id="ckTableWin"><div id="ckTableWinContent" style="padding:10px;"></div></div>').appendTo('body');
		GV.ckTableWin.dialog({
			iconCls:'icon-w-batch-cfg',
			modal:true,
			width:cfg.width||500,
			height:cfg.height||300,
			title:'设置',
			buttons:[
				{
					text:'保存'	,
					handler:function(){
						var temp=[];
						$('#ckTableWinContent').find('table td input').each(function(){
							if($(this).checkbox('getValue')){
								temp.push($(this).val());
							}	
						})
						var result=temp.join('|');
						if (GV.ckTableWin.dialog('options').title=="设定显示项"){
							if(result==""){
								$.messager.popover({msg: '至少选择一项显示项',type:'alert'});
								GV.ckTableWin.dialog('close');
							}else if (result!=queryCode){
								$m({
									ClassName:'icare.web.TimeLineData'	,
									MethodName:'SaveSearchCode',
									wantreturnval:1,
									SearchCode:result,
									TimeLineId:timeLineId
								},function(res){
									if (res==1){
										location.reload();
									}else{
										$.messager.popover({msg: '保存失败,'+res.split('^')[1],type:'error'});
										GV.ckTableWin.dialog('close');
									}
								})
							}else{
								$.messager.popover({msg: '未做更改',type:'alert'});
								GV.ckTableWin.dialog('close');
							}
						}else if(GV.ckTableWin.dialog('options').title=="设定药品显示项"){
							if(result==""){
								$.messager.popover({msg: '至少选择一项药品',type:'alert'});
								GV.ckTableWin.dialog('close');
							}else if (result!=GV.DataConfig.showDrugNames.join("|")){
								GV.DataConfig.showDrugNames=temp
								reFillLongDrugData(); //重新填充长期药品数据
								GV.ckTableWin.dialog('close');
							}else{
								$.messager.popover({msg: '未做更改',type:'alert'});
								GV.ckTableWin.dialog('close');
							}
							
						}else if(GV.ckTableWin.dialog('options').title=="设定显示科室"){
							if(result==""){
								$.messager.popover({msg: '至少选择一个科室',type:'alert'});
								GV.ckTableWin.dialog('close');
							}else if (result!=GV.DataConfig.showDepartNames.join("|")){
								GV.DataConfig.showDepartNames=temp;
								$m({
									ClassName:'icare.web.TimeLineData'	,
									MethodName:'SetDepartmentNames',
									wantreturnval:1,
									PatientID:patientID,
									departNames:result
								},function(res){
									var newHref = location.href.replace("&SetDepart=1", "");
    								location.href = newHref + "&SetDepart=1";
								})
								GV.ckTableWin.dialog('close');
							}else{
								$.messager.popover({msg: '未做更改',type:'alert'});
								GV.ckTableWin.dialog('close');
							}
							
						}
					}
				},{
					text:'关闭'	,
					handler:function(){
						//alert('关闭');
						GV.ckTableWin.dialog('close');
					}
				}
			]
		})
	}
	$('#ckTableWinContent').html($('#ckTableTmpl').tmpl(data));
	GV.ckTableWin.dialog({
		width:cfg.width||500,
		height:cfg.height||300,
		title:cfg.title||'设置'
	}).window('open');

	$.parser.parse('#ckTableWinContent');
}
function showViewConfig(){
	var temp={cols:3,list:[]};
	$.each(GV.AllCategroyData.CategroyConfig,function(idx,oneItem){
		var str=oneItem.CategroyCode + ":" + oneItem.DataTypeCode + ":" + oneItem.ViewType;
		temp.list.push({text:oneItem.DataTypeDesc,value:str,checked:queryCode.indexOf(str)>-1});
	})
	showCkTableWin(temp,{title:'设定显示项',width:500});

}

function changeDate(date){
	$m({
		ClassName:'icare.web.TimeLineData'	,
		MethodName:'GetTimeLineData',
		wantreturnval:0,
		SearchCode:queryCode,
		EpisodeID:episodeId,
		PatientID:patientID,
		StartDate:date
	},function(res){
		ClinicalData=eval("("+res+")");
		//console.log('changeDate',ClinicalData);
		clearData();
		fillData();
	})
}
function bloodPressure_changeDate(date){
	$m({
		ClassName:'icare.web.TimeLineData'	,
		MethodName:'GetDataTypeData',
		wantreturnval:0,
		EpisodeID:episodeId,
		StartDate:date,
		DataTypeCode:"0306"
	},function(res){
		BloodPressureInfor=eval("("+res+")");
		queryDate=date;
		transData2ClinicalData(BloodPressureInfor);
		//console.log('bloodPressure_changeDate',ClinicalData);
		clearData();
		fillData();
	})
}
function out_changeDate(lstEpisodeId){
	$m({
		ClassName:'icare.web.TimeLineData'	,
		MethodName:'GetTimeLineData',
		wantreturnval:0,
		SearchCode:queryCode,
		EpisodeID:episodeId,
		PatientID:patientID,
		lstEpisodeId:lstEpisodeId
	},function(res){
		//门诊的在lstEpisodeId不为空时，输出的并不是完整的ClinicalData  ， EpisodeList
		var tempClinicalData=eval("("+res+")");
		ClinicalData.DataArray = tempClinicalData.DataArray;
        ClinicalData.queryEpisodelst = tempClinicalData.queryEpisodelst;
		//console.log('out_changeDate',ClinicalData);
		clearData();
		fillData();
	})
}
function diagnose_changeDate(index){
	$m({
		ClassName:'icare.web.TimeLineData'	,
		MethodName:'GetDiagnoseInfor',
		wantreturnval:0,
		EpisodeID:episodeId,
		StartIndex:index,
		PageCount:7
	},function(res){
		DiagnoseInfor=eval("("+res+")");
		transData2ClinicalData(DiagnoseInfor);
		//console.log('diagnose_changeDate',ClinicalData);
		clearData();
		fillData();
	})
}


$(function(){
	init();
})


