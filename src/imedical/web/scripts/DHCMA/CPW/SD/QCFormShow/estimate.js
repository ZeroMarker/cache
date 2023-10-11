function InitEstimate(obj){
	//初始化评分项信息
	obj.ScoreArr=new Array();
	//评估量表div
	html='<div id="winVal">'   
	html+='<div id="ValDic"></div>'
	html+='</div>'
	html+='<div id="tools" style="height:30px">'
	html+='<div href="#" style="float:left">得分：<span id="tScore" style="color:#5B89EB;font-size:15px;font-weight:bold;"></span></div>'
	html+='<div href="#" style="float:right;padding-right:20px;">'
	html+='<a href="#" id="ExitScore" class="hisui-linkbutton hover-dark">确定</a>'
	html+='</div>'
	html+='</div>'
	$("body").append(html)
	//初始化评估量表
	$('#winVal').dialog({
		title:"",
		closed: true,
		closable:false,
		iconCls:'icon-w-save',
		modal: true,
		center:true,
		width:'600',
		height:document.documentElement.clientHeight-20,
		onClose:function(){
			$(document.body).css({ 
			   "overflow-y":"auto" 
			 });
		},
		onBeforeOpen:function(){
			$(document.body).css({ 
			   "overflow-y":"hidden"
			 });	
		},
		buttons:'#tools'
		
	});
	$('#ExitScore').on('click',function () {
			var tscore=$('#tScore').text();
			var tsval=$('#tScore').val();
			try {
				obj.setItemVal(obj.EditCode,tscore,tsval);
			}catch(e){
				$.messager.alert("赋值错误", "表单程序缺少赋值函数[obj.setItemVal]", 'error');
			}
			$HUI.dialog('#winVal').close();
	})
	obj.OpenCalcWindow=function(sheetid,itemcode) {
		obj.CalcResult=""
		///展现评分表内容
		var sheetdata=$m({
			ClassName:'DHCMA.CPW.SD.EvalSheet',
			MethodName:'GetObjById',
			aId:sheetid
		},false)
		var sheetobj=eval('(' + sheetdata + ')')
		obj.EditCode=itemcode
		obj.showEvalSheet(sheetobj.EvalCode,sheetobj.EvalDesc);
		obj.displaySheet(itemcode);
	}
	obj.showEvalSheet=function(aSheetCode,aSheetTitle){
			var listHtml=""
			//初始化分值
			$('#tScore').text('');
			//动态生成评分表html
			var listHtml=listHtml+'<div>'
			var itemdata=$cm({
				ClassName:'DHCMA.CPW.SDS.EvalSrv',
				QueryName:'QryEItemByCode',
				aSheetCode:aSheetCode,
				rows:1000
			},false)
			var itemlen=itemdata.rows.length
			var itemPWidth='200px';
			if (itemlen==1) itemPWidth='98%';  //唯一评分项  展开全部 
			var listHtml=listHtml+'<div>'
			var itemhtml=""
			var HCount=0 //加载行div
			var itemCount=0 //默认列数
			for (var xind=0;xind<itemlen;xind++) {
				var xitem=itemdata.rows[xind]
				var itemid=xitem.RowID
				var itemcode=xitem.ICode
				var itemdesc=xitem.IDesc
				var multiple=xitem.IMul?true:false;
				//从代码处理当前项目位置信息
				var xitemcode=itemcode.replace(aSheetCode,"")
				var xitemcodeArr	= xitemcode.split('-')
				var xhcount			= xitemcodeArr[1]   //行位置
				var xvcount			= xitemcodeArr[2]	//列位置
				var xstyle			= xitemcodeArr[3]	//合并样式
				var IComb=xitem.IComb
				if (xhcount!=HCount) {
					itemCount=1 //默认一行一列
					if (HCount>0) {
						//给上一个div加上结束标签
						var itemhtml=itemhtml+'</div>'
					}
					if (IComb==3){
						var itemhtml=itemhtml+'<div class="item-h3" id="hdiv'+xhcount+'">'
					}else{
						var itemhtml=itemhtml+'<div class="item-h" id="hdiv'+xhcount+'">'
					}
					HCount=xhcount
					//新写入一行前，计算总列数
					for (var yind=xind+1;yind<itemlen;yind++) {
						var yitem=itemdata.rows[yind]
						var yitemcode=yitem.ICode
						var yitemcode=yitemcode.replace(aSheetCode,"")
						var yitemcodeArr	= yitemcode.split('-')
						var yhcount			= yitemcodeArr[1]   //行位置
						if (yhcount!=xhcount) break;
						var yvcount			= yitemcodeArr[2]	//列位置
						if (yvcount>0) itemCount=yvcount
					}
					
				}
				if (itemCount==0) continue;
				var itemdicdata=$cm({
					ClassName:'DHCMA.CPW.SDS.EvalSrv',
					QueryName:'QryEDicByItemID',
					aitemid:itemid,
					rows:1000
				},false)
				var itemdicLen=itemdicdata.rows.length
				if (IComb==3) {
					//横分表构建
					//第一个评分项构建评分表头
					var titlehtml="",dichtml=""
					if (xind==0) {
						//计算列宽
						var colWidth=99/(itemdicLen+1)+"%"
						//补项目分类头
						var titlehtml=titlehtml+'<div class="dic-title" style="width:'+colWidth+'">'+"项目"+'</div>'
						var dichtml='<div data-multiple='+multiple+'><div class="dic-title3" style="width:'+colWidth+'">'+itemdesc+'</div>'
						for (var dind=0;dind<itemdicLen;dind++) {
							var xitemdic=itemdicdata.rows[dind]
							var EDRowID	= xitemdic.RowID
							var EDCode	= xitemdic.EDCode
							var EDDesc	= xitemdic.EDDesc
							var EDScore	= xitemdic.EDScore	
							var EDType	= xitemdic.EDType
							var EDExp	= xitemdic.EDExp
							var EDGroup	= xitemdic.EDGroup
							var EDLink	= xitemdic.EDLink
							var titlehtml=titlehtml+'<div class="dic-title" style="width:'+colWidth+'">'+EDScore+'</div>'
							var dichtml=dichtml+'<div id='+EDRowID+' class="dic-desc" data-calc="'+EDExp+'"  data-score="'+EDScore+'" data-link="'+EDLink+'" data-group="'+EDGroup+'" style="width:'+colWidth+';">'+EDDesc+'</div>'
						}
						var dichtml=dichtml+'</div>'
						titlehtml='<div style="margin-top:10px;" class="item-h3" id="hdiv'+0+'">'+titlehtml+'</div>'
						dichtml='<div class="item-h3" id="hdiv'+1+'">'+dichtml+'</div>'
						itemhtml=titlehtml+dichtml
					}else {
						var dichtml='<div data-multiple='+multiple+'><div class="dic-title3" style="width:'+colWidth+'">'+itemdesc+'</div>'
						for (var dind=0;dind<itemdicLen;dind++) {
							var xitemdic=itemdicdata.rows[dind]
							var EDRowID	= xitemdic.RowID
							var EDCode	= xitemdic.EDCode
							var EDDesc	= xitemdic.EDDesc
							var EDScore	= xitemdic.EDScore	
							var EDType	= xitemdic.EDType
							var EDExp	= xitemdic.EDExp
							var EDGroup	= xitemdic.EDGroup
							var EDLink	= xitemdic.EDLink
							var dichtml=dichtml+'<div id='+EDRowID+' class="dic-desc" data-calc="'+EDExp+'"  data-score="'+EDScore+'" data-link="'+EDLink+'" data-group="'+EDGroup+'" style="width:'+colWidth+';">'+EDDesc+'</div>'
						}
						var dichtml=dichtml+'</div>'
						itemhtml=itemhtml+dichtml
					}
				}else if(IComb==2){
					var itemWidth=99/itemCount+"%"
					var itemhtml=itemhtml+'<div class="item-panel" data-multiple='+multiple+' style="width:'+itemWidth+';">'
					var itemhtml=itemhtml+'<div class="dic-title">'+itemdesc+'</div>'
					var itemdicLen=itemdicdata.rows.length
					for (var dind=0;dind<itemdicLen;dind++) {
						var xitemdic=itemdicdata.rows[dind]
						var EDRowID	= xitemdic.RowID
						var EDCode	= xitemdic.EDCode
						var EDDesc	= xitemdic.EDDesc
						var EDScore	= xitemdic.EDScore	
						var EDType	= xitemdic.EDType
						var EDExp	= xitemdic.EDExp
						var EDGroup	= xitemdic.EDGroup
						var EDLink	= xitemdic.EDLink
						var EDDesc=EDDesc.replace(/\r\n/g,"<br>")
						var itemhtml=itemhtml+'<div id='+EDRowID+' class="dic-desc" data-calc=\"'+EDExp+'\"  data-score=\"'+EDScore+'\" data-link=\"'+EDLink+'\" data-group=\"'+EDGroup+'\" style="float:left;width:98%;height:100%;">'+EDDesc+'</div>'
						var itemhtml=itemhtml+'<div style="clear:both"></div>'
					}
					var itemhtml=itemhtml+'</div>'
				}else{
					var itemWidth=99/itemCount+"%"
					var itemhtml=itemhtml+'<div class="item-panel" data-multiple='+multiple+' style="width:'+itemWidth+';">'
					var itemhtml=itemhtml+'<div class="dic-title">'+itemdesc+'</div>'
					var itemdicLen=itemdicdata.rows.length
					for (var dind=0;dind<itemdicLen;dind++) {
						var xitemdic=itemdicdata.rows[dind]
						var EDRowID	= xitemdic.RowID
						var EDCode	= xitemdic.EDCode
						var EDDesc	= xitemdic.EDDesc
						var EDScore	= xitemdic.EDScore	
						var EDType	= xitemdic.EDType
						var EDExp	= xitemdic.EDExp
						var EDGroup	= xitemdic.EDGroup
						var EDLink	= xitemdic.EDLink
						var EDDesc=EDDesc.replace(/\r\n/g,"<br>")
						var EDDesc=EDDesc.replace(/\s/g,"<br>")
						/*
						<input id="huodongdu" placeholder="8度=1分，最高18分">
						<div>每5度外翻<input id="waifandu">度</div>
						*/
						var itemhtml=itemhtml+'<div class="dic-score">'+EDScore+'</div>'
						if (EDType=="input") {
							if (EDExp=="") {
								var itemhtml=itemhtml+'<div style="float:left;"><input id='+EDRowID+' class="dic-input" placeholder='+EDDesc+'></div>'
							}else{
								var itemhtml=itemhtml+'<div style="float:left;">'+EDDesc+'<input id='+EDRowID+' data-calc=\"'+EDExp+'\" class="dic-input"></div>'
							}
						}else{
							var itemhtml=itemhtml+'<div id='+EDRowID+' class="dic-desc" data-calc=\"'+EDExp+'\"  data-score=\"'+EDScore+'\" data-link=\"'+EDLink+'\" data-group=\"'+EDGroup+'\" >'+EDDesc+'</div>'
						}
						var itemhtml=itemhtml+'<div style="clear:both"></div>'
					}
					var itemhtml=itemhtml+'</div>'
				}
				
			}	
			var listHtml=listHtml+itemhtml
			var listHtml=listHtml+'</div>'  //最后一个行div结束
			var listHtml=listHtml+'</div></div>'
			$('#ValDic').html(listHtml)
			$.parser.parse('#winVal');
			$('#winVal').dialog({title:aSheetTitle})
			$HUI.dialog('#winVal').open();
			//选中div时 计算分值
			$('.dic-desc').on('click',function(){
				
				//如果容器标记为单选，则先移除所有选中，再选中当前
				if ($(this).parent().attr('data-multiple')=='false') {	
					if ($(this).hasClass('dic-desc-selected')) {
						$(this).parent().find('.dic-desc-selected').removeClass('dic-desc-selected');
					}else {
						$(this).parent().find('.dic-desc-selected').removeClass('dic-desc-selected');
						$(this).addClass('dic-desc-selected');	
					}
				}else{
					//如果容器标记为多选，则当前切换选中状态
					$(this).toggleClass('dic-desc-selected');
				}
				//搜索父容器下所有互斥项，取消所有互斥项的选中状态
				if ($(this).hasClass('dic-desc-selected')) {
					var selectedText=$(this).text();
					var selectedid=$(this)[0].id;
					var groupinfo=$(this).attr('data-group');
					var linkinfo=$(this).attr('data-link');
					if (groupinfo) {
						//清除同分组信息下的其他选项
						$('div[data-group='+groupinfo+']').each(function(i, v){
							if (selectedid!=$(this)[0].id) {
								$(this).removeClass('dic-desc-selected');
							}
						})
					}
					if (linkinfo) {
						//选中相关联的其他选项
						$('div').find('.dic-desc-selected').removeClass('dic-desc-selected');
						$('div[data-link='+linkinfo+']').each(function(i, v){
								$(this).addClass('dic-desc-selected');
						})	
					}
				}
				obj.CalVal(aSheetCode);
			})
			//输入框计算到总分值
			$('.dic-input').on('input',function(){
				obj.CalVal(aSheetCode);
			})
	}
	//每次选中/填写评估表，计算当前所得分值
	obj.CalVal=function(aSheetCode){
		//初始化评估得分、值、评分字典
		var tscore=0,tval="",selectdicstr=""
		obj.ScoreArr[obj.EditCode]=""
		$('div').find('.dic-desc-selected').each(function(i, v){
			var xscore=$(this).attr('data-score')
			selectdicstr=selectdicstr+"^"+$(this).attr('id')
			if (!isNaN(parseInt(xscore))) {
				//分值评定，分值相加
				tscore=tscore+parseInt(xscore)
			}else {
				//等级评估，直接显示等级描述
				tscore=xscore
				//如果有计算表达式，按照计算公式进行转换
				texp=$(this).attr('data-calc')
				if (texp) {
					texp.replace('this',xscore)
					tval=eval('texp')	
				}
			}
		})
		
		$('.dic-input').each(function(i, v){
			texp=$(this).attr('data-calc')
			xscore=$(this).val()
			if (xscore!="") {
				if (texp) {
					texp=texp.replace(/this/g,xscore)
					//计算表达式结果值 保留2位小数
					xscore=eval(texp).toFixed(2)	
				}
				tscore=tscore+Number(xscore)
				selectdicstr=selectdicstr+"^"+$(this).attr('id')+"`"+$(this).val()
			}
		})
		if(!isNaN(tscore)) {
			$('#tScore').text(Number(tscore.toFixed(2)));
		}else {
			$('#tScore').text(tscore);
		}
		if (tval) {
			$('#tScore').val(tval)
		}
		obj.ScoreArr[obj.EditCode]=tscore+"#"+selectdicstr
	}
	//初始化评估表内容
	obj.displaySheet=function(aCode) {	
		if (obj.ScoreArr[aCode]){
			var scoredicstr=obj.ScoreArr[aCode].split('#')[1]
			var scoredicArr=scoredicstr.split('^')
			for (var sind=1;sind<scoredicArr.length;sind++) {
				var dicid=scoredicArr[sind]
				if (dicid.indexOf('`')>-1) {
					$('[id="'+dicid.split('`')[0]+'"]').val(dicid.split('`')[1])
				}else{
					$('[id="'+dicid+'"]').addClass('dic-desc-selected')	
				}
			}	
			obj.CalVal()
		}	
	}
}