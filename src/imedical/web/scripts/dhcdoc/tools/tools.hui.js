var DocToolsHUI={
	lib:{
	pagerFilter:function pagerFilter(data){
		if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
			data = {
				total: data.length,
				rows: data
			}
		}
		var dg = $(this);
		var opts = dg.datagrid('options');
		var pager = dg.datagrid('getPager');
		pager.pagination({
			showRefresh:false,
			onSelectPage:function(pageNum, pageSize){
				dg.datagrid('unselectAll');
				opts.pageNumber = pageNum;
				opts.pageSize = pageSize;
				pager.pagination('refresh',{
					pageNumber:pageNum,
					pageSize:pageSize
				});
				dg.datagrid('loadData',data);
				dg.datagrid('scrollTo',0); //������ָ������        
			}
		});
		if (!data.originalRows){
			data.originalRows = (data.rows);
		}
		if (opts.pagination){
			if (data.originalRows.length>0) {
				var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
				if ((start+1)>data.originalRows.length){
					//ȡ���������������ҳ��ʼֵ
					start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
					opts.pageNumber=(start/opts.pageSize)+1;
				}
				//���ҳ����ʾ����ȷ������
				$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
				
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
			}
		}
		return data;
		}
	},
	MessageQueue:{
		Queue: {},
		Add: function(MsgType,$Msg){
			if ((typeof MsgType=="undefined")||(typeof $Msg=="undefined")){
				return;   
			}
			if (this.Queue[MsgType] instanceof Array ===false){
			   this.Queue[MsgType]=new Array();
			}
			this.Queue[MsgType].push($Msg);
			return $Msg;
		},
		///����ִֹͣ��Ajax���󣬷�ֹ��ͬ�������ͬһDOM���������½��������쳣
		FireAjax:   function (MsgType) {
			this.EachDel(MsgType,function($Ajax){
				if($Ajax.readyState == 4 && $Ajax.status == 200) {
					return;
				}
				$Ajax.abort();
			});
		},
		EachDel:   function (MsgType,callBack) {
			if (this.Queue[MsgType] instanceof Array ===false){
				return;
			}
		    var $Msg;
			for(var i=0; i<this.Queue[MsgType].length; i++){
				$Msg=this.Queue[MsgType][i];
				this.Queue[MsgType].splice(i--, 1);
				if (callBack($Msg)===false){
					break;
				}
			}
         }

	}
};