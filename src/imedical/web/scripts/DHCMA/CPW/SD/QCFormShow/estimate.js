function InitEstimate(obj){
	//��ʼ����������Ϣ
	obj.ScoreArr=new Array();
	//��������div
	html='<div id="winVal">'   
	html+='<div id="ValDic"></div>'
	html+='</div>'
	html+='<div id="tools" style="height:30px">'
	html+='<div href="#" style="float:left">�÷֣�<span id="tScore" style="color:#5B89EB;font-size:15px;font-weight:bold;"></span></div>'
	html+='<div href="#" style="float:right;padding-right:20px;">'
	html+='<a href="#" id="ExitScore" class="hisui-linkbutton hover-dark">ȷ��</a>'
	html+='</div>'
	html+='</div>'
	$("body").append(html)
	//��ʼ����������
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
				$.messager.alert("��ֵ����", "������ȱ�ٸ�ֵ����[obj.setItemVal]", 'error');
			}
			$HUI.dialog('#winVal').close();
	})
	obj.OpenCalcWindow=function(sheetid,itemcode) {
		obj.CalcResult=""
		///չ�����ֱ�����
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
			//��ʼ����ֵ
			$('#tScore').text('');
			//��̬�������ֱ�html
			var listHtml=listHtml+'<div>'
			var itemdata=$cm({
				ClassName:'DHCMA.CPW.SDS.EvalSrv',
				QueryName:'QryEItemByCode',
				aSheetCode:aSheetCode,
				rows:1000
			},false)
			var itemlen=itemdata.rows.length
			var itemPWidth='200px';
			if (itemlen==1) itemPWidth='98%';  //Ψһ������  չ��ȫ�� 
			var listHtml=listHtml+'<div>'
			var itemhtml=""
			var HCount=0 //������div
			var itemCount=0 //Ĭ������
			for (var xind=0;xind<itemlen;xind++) {
				var xitem=itemdata.rows[xind]
				var itemid=xitem.RowID
				var itemcode=xitem.ICode
				var itemdesc=xitem.IDesc
				var multiple=xitem.IMul?true:false;
				//�Ӵ��봦��ǰ��Ŀλ����Ϣ
				var xitemcode=itemcode.replace(aSheetCode,"")
				var xitemcodeArr	= xitemcode.split('-')
				var xhcount			= xitemcodeArr[1]   //��λ��
				var xvcount			= xitemcodeArr[2]	//��λ��
				var xstyle			= xitemcodeArr[3]	//�ϲ���ʽ
				var IComb=xitem.IComb
				if (xhcount!=HCount) {
					itemCount=1 //Ĭ��һ��һ��
					if (HCount>0) {
						//����һ��div���Ͻ�����ǩ
						var itemhtml=itemhtml+'</div>'
					}
					if (IComb==3){
						var itemhtml=itemhtml+'<div class="item-h3" id="hdiv'+xhcount+'">'
					}else{
						var itemhtml=itemhtml+'<div class="item-h" id="hdiv'+xhcount+'">'
					}
					HCount=xhcount
					//��д��һ��ǰ������������
					for (var yind=xind+1;yind<itemlen;yind++) {
						var yitem=itemdata.rows[yind]
						var yitemcode=yitem.ICode
						var yitemcode=yitemcode.replace(aSheetCode,"")
						var yitemcodeArr	= yitemcode.split('-')
						var yhcount			= yitemcodeArr[1]   //��λ��
						if (yhcount!=xhcount) break;
						var yvcount			= yitemcodeArr[2]	//��λ��
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
					//��ֱ���
					//��һ������������ֱ�ͷ
					var titlehtml="",dichtml=""
					if (xind==0) {
						//�����п�
						var colWidth=99/(itemdicLen+1)+"%"
						//����Ŀ����ͷ
						var titlehtml=titlehtml+'<div class="dic-title" style="width:'+colWidth+'">'+"��Ŀ"+'</div>'
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
						<input id="huodongdu" placeholder="8��=1�֣����18��">
						<div>ÿ5���ⷭ<input id="waifandu">��</div>
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
			var listHtml=listHtml+'</div>'  //���һ����div����
			var listHtml=listHtml+'</div></div>'
			$('#ValDic').html(listHtml)
			$.parser.parse('#winVal');
			$('#winVal').dialog({title:aSheetTitle})
			$HUI.dialog('#winVal').open();
			//ѡ��divʱ �����ֵ
			$('.dic-desc').on('click',function(){
				
				//����������Ϊ��ѡ�������Ƴ�����ѡ�У���ѡ�е�ǰ
				if ($(this).parent().attr('data-multiple')=='false') {	
					if ($(this).hasClass('dic-desc-selected')) {
						$(this).parent().find('.dic-desc-selected').removeClass('dic-desc-selected');
					}else {
						$(this).parent().find('.dic-desc-selected').removeClass('dic-desc-selected');
						$(this).addClass('dic-desc-selected');	
					}
				}else{
					//����������Ϊ��ѡ����ǰ�л�ѡ��״̬
					$(this).toggleClass('dic-desc-selected');
				}
				//���������������л����ȡ�����л������ѡ��״̬
				if ($(this).hasClass('dic-desc-selected')) {
					var selectedText=$(this).text();
					var selectedid=$(this)[0].id;
					var groupinfo=$(this).attr('data-group');
					var linkinfo=$(this).attr('data-link');
					if (groupinfo) {
						//���ͬ������Ϣ�µ�����ѡ��
						$('div[data-group='+groupinfo+']').each(function(i, v){
							if (selectedid!=$(this)[0].id) {
								$(this).removeClass('dic-desc-selected');
							}
						})
					}
					if (linkinfo) {
						//ѡ�������������ѡ��
						$('div').find('.dic-desc-selected').removeClass('dic-desc-selected');
						$('div[data-link='+linkinfo+']').each(function(i, v){
								$(this).addClass('dic-desc-selected');
						})	
					}
				}
				obj.CalVal(aSheetCode);
			})
			//�������㵽�ܷ�ֵ
			$('.dic-input').on('input',function(){
				obj.CalVal(aSheetCode);
			})
	}
	//ÿ��ѡ��/��д���������㵱ǰ���÷�ֵ
	obj.CalVal=function(aSheetCode){
		//��ʼ�������÷֡�ֵ�������ֵ�
		var tscore=0,tval="",selectdicstr=""
		obj.ScoreArr[obj.EditCode]=""
		$('div').find('.dic-desc-selected').each(function(i, v){
			var xscore=$(this).attr('data-score')
			selectdicstr=selectdicstr+"^"+$(this).attr('id')
			if (!isNaN(parseInt(xscore))) {
				//��ֵ��������ֵ���
				tscore=tscore+parseInt(xscore)
			}else {
				//�ȼ�������ֱ����ʾ�ȼ�����
				tscore=xscore
				//����м�����ʽ�����ռ��㹫ʽ����ת��
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
					//������ʽ���ֵ ����2λС��
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
	//��ʼ������������
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