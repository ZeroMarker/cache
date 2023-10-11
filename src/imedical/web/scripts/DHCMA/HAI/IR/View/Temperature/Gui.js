//页面Gui
function InitTemperatureWin(){
	    var obj = new Object();
        var res = $cm({
        ClassName: "DHCHAI.DPS.PAAdmSrv",
        QueryName: "QryAdmWeeks",
        aEpisodeID: PaadmID,
        page: 1,
        rows: 99999
        }, false);
        
        if(res.total <= 12){
            var datato=res.rows[0].weekValue.split("-")[1];
            var datafrom=res.rows[res.total-1].weekValue.split("-")[0];
            var value1=datafrom+"-"+datato;
            var show1="全部";
        }else{
            var datato=res.rows[0].weekValue.split("-")[1];
            var datafrom=res.rows[12].weekValue.split("-")[0];
            var value1=datafrom+"-"+datato;
            var show1="全部";
        }           //默认最大显示十二周
        var data1=[];
        for (var i=0;i <= res.total;i++){
            data1[i]=new Object();
            if(i==0){
                data1[i].weekshow=show1;
                data1[i].weekvalue=value1;
            }else{
                data1[i].weekshow=res.rows[i-1].weekShow;
                data1[i].weekvalue=res.rows[i-1].weekValue;
            }
		}
        $HUI.combobox("#cboWeeks", {
            data: data1,
            valueField: 'weekvalue',
            textField: 'weekshow',
            onLoadSuccess:function(data){
                // 院区默认选择
                $('#cboWeeks').combobox('select',data[1].weekvalue);
            }
        });
        
        
	InitTemperatureWinEvent(obj);
	return obj;
}