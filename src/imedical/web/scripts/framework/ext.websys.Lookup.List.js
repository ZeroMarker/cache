/// ext.websys.Lookup.List.js
/// look up 


//var m_PageHeight=200;
//var m_PageWidth=300;
/// ����Lookup����
///150 ��͵ĸ߶�
///û������ʱ��ʾ  500
///����ʾҳ��ʱ�G  150+30*PageSize
var m_PageHeight=500;
var m_PageWidth=400;
var m_PageSize=15;
var m_ByteWidth=7;
var grid,pagingBar;	//����ʵ��pagedown��pageup
function ResizePageHandler(rows, cols) {
	if (m_PageSize>0){
		m_PageHeight=150+(25*15);
	} 
	if (m_PageWidth<350){
		m_PageWidth=400;
		}
	else{
		var screenWidth=top.window.screen.width*0.8;
		if (m_PageWidth > screenWidth){
			m_PageWidth = screenWidth;
		}
	}
	window.resizeTo(m_PageWidth, m_PageHeight);
}

Ext.onReady(function(){
		Ext.QuickTips.init();
		var myclassname="";		
		var myqueryname="";

    Ext.getUrlParam = function(param) {
        var str = location.search.substring(1);	 
        var ind = str.indexOf(param+"=");
        if (ind>-1){
	        var start = ind+param.length+1;
	        var end = str.indexOf("&",start);
	        if (end==-1) return str.slice(start);
        	return str.slice(start,end);
        }
        return "";
        var params = Ext.urlDecode(location.search.substring(1));
        return param ? params[param] : params;
    };
		
		var myID=Ext.getUrlParam('ID');
		var myCONTEXT=Ext.getUrlParam("CONTEXT");
		var mycontextary=myCONTEXT.split(":");
		
		///��ȡQuery����
		myclassname=mycontextary[0].substring(1);
		myqueryname=mycontextary[1];

		/// ��ȡ��������, ��ҳ��Ĳ������ǹ̶��ģ� �ɵ��ý����ṩ
		var myparacount=20;
		var myparastr="";
		var mypvalue="";
		myparastr= "'pClassName' : '" + myclassname + "', ";
		myparastr += "'pClassQuery' : " + "'"+myqueryname +"'";
		
		///��request������֯Ϊjson��ʽ
		for (var myIdx=1; myIdx<myparacount; myIdx++){
			mypvalue=Ext.getUrlParam("P"+myIdx);
			if ((typeof(mypvalue)=="undefined")||(mypvalue==null)){
				continue;
			}
			if (myparastr!=""){
				myparastr+=", ";
			}
			myparastr+=("'P"+myIdx)+ "' : " + "'"+mypvalue+"'";
		}
		if (myparastr!=""){
				myparastr+=", ";
		}
		myparastr+="'rnd' : '"+Math.random()+"'";
		myparastr="{"+myparastr+"}";
		var myparajson=Ext.decode(myparastr);
		
		
		/// ���grid����metdata
		var mymodalstr=tkMakeServerCall("ext.websys.QueryBroker", "ReadRS", myclassname, myqueryname);
		var json=Ext.decode(mymodalstr);
		var cm = new Ext.grid.ColumnModel(json.cms);
		
		/// ����datastors
		var mycmurl="ext.websys.querydatatrans.csp";
		var ds = new Ext.data.JsonStore({
	      url:mycmurl,
	      baseParams:myparajson,
	      root:"record",
	      totalProperty:"total",
	      fields: json.fns
    });
    
    /// ����pagingBar
    pagingBar = new Ext.PagingToolbar({
	            pageSize: 15,
	            store: ds,
	            displayInfo: true,
	            displayMsg: '{0}-{1},��{2}��'
	            //emptyMsg: "û�м�¼"
    });
    var myloadM;
		if (Ext.isIE){
			myloadM = new Ext.LoadMask(Ext.getBody(), {msg:"���ڼ�������..."});
		}else{
			myloadM = true;
		}
    
  	/// ����grid
  	grid = new Ext.grid.GridPanel({
  					id:"lookupdata",
  					title:"",
            region: 'center',
            split: true,
            border:false,
            width:80,
            height:180,
            cm:cm,
            ds:ds,
            loadMask:myloadM,
            stripeRows:true,
        	  bbar:pagingBar
		});
		
		/// grid �¼�
		grid.on({
			rowclick:function(grid, rowIndex,e){
				selectRow();
			},
			keydown:function(e){
				//�����¼�������Ч,websys.js�ڼ�����keydown. websys.lookup.csp����дkeydown�¼�
				if (e.getKey() == e.ENTER){
					selectRow();
				}
			}
		});
		new Ext.Viewport({
			layout: 'border',
			split: true,
			items: [grid]
		});
		
		
		/// ѡ���к��д���� �¼�
		var selectRow = function (){
			var tmpRecord = grid.getSelectionModel().getSelected();
			var myColAry="";
				for(var myIdx=0;myIdx<json.fns.length;myIdx++){
					//wanghc �����һ��Ϊ��,��˳������
					if(myIdx==0){
						myColAry = tmpRecord.get(json.fns[myIdx].name);
					}else{
						myColAry += "^";
						myColAry += tmpRecord.get(json.fns[myIdx].name);
					}
				}
				GridRowSelect(tmpRecord.get(json.fns[0].name),myColAry);
				window.close();
				return;
				
		}
		
		/// ds.onload  �������ݺ󴥷��¼������¼����п�
    ds.on({
			load:function(s,rs,obj){
				m_PageWidth=0;
				for(var cm_i=0;cm_i<cm.config.length;cm_i++){
					if (cm.config[cm_i].hidden) continue;
					var objWidth=new Object;
					objWidth.key=cm.config[cm_i].dataIndex;
					objWidth.val=cm.config[cm_i].width;
					
					for(var rs_i=0;rs_i<rs.length;rs_i++){
						var len=rs[rs_i].get(objWidth.key).replace(/[^\x00-\xff]/g,"**").length * m_ByteWidth;
						if (len>objWidth.val){
							objWidth.val=len;
						}
					}
					cm.config[cm_i].width=objWidth.val;
					m_PageWidth+=objWidth.val;
			    }
				grid.reconfigure(ds,cm);
				ResizePageHandler(0, 0);
				//wanghc 21040917 �ڴ�load�궼ѡ�е�һ��
				grid.getSelectionModel().selectFirstRow();
	 			var row = grid.getView().getRow(0);
				if (row) Ext.get(row).focus();
		  }
    });
	ds.load({params:{start:0,limit:pagingBar.pageSize, pPageSize:pagingBar.pageSize, pPageIdx:pagingBar.pageIndex}});
});




