/* *
 * ȫ�ֿռ� Vcity
 * */
var Vcity = {};
/* *
 * ��̬������
 * @name _m
 * */
Vcity._m = {
    /* ѡ��Ԫ�� */
    $:function (arg, context) {
        var tagAll, n, eles = [], i, sub = arg.substring(1);
        context = context || document;
        if (typeof arg == 'string') {
            switch (arg.charAt(0)) {
                case '#':
                    return document.getElementById(sub);
                    break;
                case '.':
                    if (context.getElementsByClassName) return context.getElementsByClassName(sub);
                    tagAll = Vcity._m.$('*', context);
                    n = tagAll.length;
                    for (i = 0; i < n; i++) {
                        if (tagAll[i].className.indexOf(sub) > -1) eles.push(tagAll[i]);
                    }
                    return eles;
                    break;
                default:
                    return context.getElementsByTagName(arg);
                    break;
            }
        }
    },

    /* ���¼� */
    on:function (node, type, handler) {
        node.addEventListener ? node.addEventListener(type, handler, false) : node.attachEvent('on' + type, handler);
    },

    /* ��ȡ�¼� */
    getEvent:function(event){
        return event || window.event;
    },

    /* ��ȡ�¼�Ŀ�� */
    getTarget:function(event){
        return event.target || event.srcElement;
    },

    /* ��ȡԪ��λ�� */
    getPos:function (node) {
        var scrollx = document.documentElement.scrollLeft || document.body.scrollLeft,
                scrollt = document.documentElement.scrollTop || document.body.scrollTop;
        var pos = node.getBoundingClientRect();
        return {top:pos.top + scrollt, right:pos.right + scrollx, bottom:pos.bottom + scrollt, left:pos.left + scrollx }
    },

    /* �����ʽ�� */
    addClass:function (c, node) {
        if(!node)return;
        node.className = Vcity._m.hasClass(c,node) ? node.className : node.className + ' ' + c ;
    },

    /* �Ƴ���ʽ�� */
    removeClass:function (c, node) {
        var reg = new RegExp("(^|\\s+)" + c + "(\\s+|$)", "g");
        if(!Vcity._m.hasClass(c,node))return;
        node.className = reg.test(node.className) ? node.className.replace(reg, '') : node.className;
    },

    /* �Ƿ���CLASS */
    hasClass:function (c, node) {
        if(!node || !node.className)return false;
        return node.className.indexOf(c)>-1;
    },

    /* ��ֹð�� */
    stopPropagation:function (event) {
        event = event || window.event;
        event.stopPropagation ? event.stopPropagation() : event.cancelBubble = true;
    },
    /* ȥ�����˿ո� */
    trim:function (str) {
        return str.replace(/^\s+|\s+$/g,'');
    }
};

/* ���г�������,���԰��ո�ʽ������ӣ�����|beijing|bj����ǰ16��Ϊ���ų��� */

Vcity.allCity = ['������|beijing|bj','�Ϻ���|shanghai|sh','������|guangzhou|gz','������|shenzhen|sz','�Ͼ���|nanjing|nj','������|hangzhou|hz','�����|tianjin|tj','������|chongqing|cq','�ɶ���|chengdu|cd','�ൺ��|qingdao|qd','������|shuzhou|sz','������|wuxi|wx','������|changzhou|cz','������|wenzhou|wz','�人��|wuhan|wh','��ɳ��|changsha|cs','ʯ��ׯ��|shijiazhuang|sjz','�ϲ���|nanchang|nc','������|sanya|sy','�Ϸ���|hefei|hf','֣����|zhengzhou|zz','������|baoding|bd','��ɽ��|tangshan|ts','�ػʵ���|qinhuangdao|qhd','������|handan|hd','��̨��|xingtai|xt','�żҿ���|zhangjiakou|zjk','�е���|chengde|cd','��ˮ��|hengshui|hs','�ȷ���|langfang|lf','������|cangzhou|cz','̫ԭ��|taiyuan|ty','��ͬ��|datong|dt','��Ȫ��|yangquan|yq','������|changzhi|cz','������|jincheng|jc','˷����|shuozhou|sz','������|jinzhong|jz','�˳���|yuncheng|yc','������|xinzhou|xz','�ٷ���|linfen|lf','������|lvliang|ll','���ͺ�����|huhehaote|hhht','��ͷ��|baotou|bt','�ں���|wuhai|wh','�����|chifeng|cf','ͨ����|tongliao|tl','������˹��|eerduosi|eeds','���ױ�����|hulunbeier|hlbe','�����׶���|bayannaoer|byne','�����첼��|wulanchabu|wlcb','�˰���|xinganmeng|xam','���ֹ�����|xilinguolemeng|xlglm','��������|alashanmeng|alsm','������|shenyang|sy','������|dalian|dl','��ɽ��|anshan|as','��˳��|fushun|fs','��Ϫ��|benxi|bx','������|dandong|dd','������|jinzhou|jz','Ӫ����|yingkou|yk','������|fuxin|fx','������|liaoyang|ly','�̽���|panjin|pj','������|tieling|tl','������|chaoyang|cy','��«����|huludao|hld','������|changchun|cc','������|jilin|jl','��ƽ��|siping|sp','��Դ��|liaoyuan|ly','ͨ����|tonghua|th','��ɽ��|baishan|bs','��ԭ��|songyuan|sy','�׳���|baicheng|bc','�ӱ߳�����������|ybcxzzzz|ybcxzzzz','��������|haerbin|heb','���������|qiqihaer|qqhe','������|jixi|jx','�׸���|hegang|hg','˫Ѽɽ��|shuangyashan|sys','������|daqing|dq','������|yichun|yc','��ľ˹��|jiamusi|jms','��̨����|qitaihe|qth','ĵ������|mudanjiang|mdj','�ں���|heihe|hh','�绯��|suihua|sh','���˰������|daxinganling|dxaldq','������|xuzhou|xz','��ͨ��|nantong|nt','���Ƹ���|lianyungang|lyg','������|huaian|ha','�γ���|yancheng|yc','������|yangzhou|yz','����|zhenjiang|zj','̩����|taizhou|tz','��Ǩ��|suqian|sq','������|ningbo|nb','������|jiaxing|jx','������|huzhou|hz','������|shaoxing|sx','��ɽ��|zhoushan|zs','������|quzhou|qz','����|jinhua|jh','̨����|taizhou|tz','��ˮ��|lishui|ls','�ߺ���|wuhu|wh','������|bengbu|bb','������|huainan|hn','��ɽ��|maanshan|mas','������|huaibei|hb','ͭ����|tongling|tl','������|anqing|aq','��ɽ��|huangshan|hs','������|chuzhou|cz','������|fuyang|fy','������|suzhou|sz','������|chaohu|ch','������|luan|la','������|bozhou|bz','������|chizhou|cz','������|xuancheng|xc','������|fuzhou|fz','������|xiamen|xm','������|putian|pt','������|sanming|sm','Ȫ����|quanzhou|qz','������|zhangzhou|zz','��ƽ��|nanping|np','������|longyan|ly','������|ningde|nd','��������|jingdezhen|jdz','Ƽ����|pingxiang|px','�Ž���|jiujiang|jj','������|xinyu|xy','ӥ̶��|yingtan|yt','������|ganzhou|gz','������|jian|ja','�˴���|yichun|yc','������|fuzhou|fz','������|shangrao|sr','������|jinan|jn','�Ͳ���|zibo|zb','��ׯ��|zaozhuang|zz','��Ӫ��|dongying|dy','��̨��|yantai|yt','Ϋ����|weifang|wf','������|jining|jn','̩����|taian|ta','������|weihai|wh','������|rizhao|rz','������|laiwu|lw','������|linyi|ly','������|dezhou|dz','�ĳ���|liaocheng|lc','������|binzhou|bz','������|heze|hz','������|kaifeng|kf','������|luoyang|ly','ƽ��ɽ��|pingdingshan|pds','������|anyang|ay','�ױ���|hebi|hb','������|xinxiang|xx','������|jiaozuo|jz','�����|puyang|py','�����|xuchang|xc','�����|luohe|lh','����Ͽ��|sanmenxia|smx','������|nanyang|ny','������|shangqiu|sq','������|xinyang|xy','�ܿ���|zhoukou|zk','פ�����|zhumadian|zmd','��Դ��|jiyuan|jiyuan','��ʯ��|huangshi|hs','ʮ����|shiyan|sy','�˲���|yichang|yc','�差��|xiangfan|xf','������|ezhou|ez','������|jingmen|jm','Т����|xiaogan|xg','������|jingzhou|jz','�Ƹ���|huanggang|hg','������|xianning|xn','������|suizhou|sz','��ʩ����������������|estjzmzzzz|estjzmzzzz','������|xiantao|xt','Ǳ����|qianjiang|qj','������|tianmen|tm','��ũ������|shennongjia|snjlq','������|zhuzhou|zz','��̶��|xiangtan|xt','������|hengyang|hy','������|shaoyang|sy','������|yueyang|yy','������|changde|cd','�żҽ���|zhangjiajie|zjj','������|yiyang|yy','������|chenzhou|cz','������|yongzhou|yz','������|huaihua|hh','¦����|loudi|ld','��������������������|xxtjzmzzzz|xxtjzmzzzz','�ع���|shaoguan|sg','�麣��|zhuhai|zh','��ͷ��|shantou|st','��ɽ��|foushan|fs','������|jiangmen|jm','տ����|zhanjiang|jz','ï����|maoming|mm','������|zhaoqing|zq','������|huizhou|hz','÷����|meizhou|mz','��β��|shanwei|sw','��Դ��|heyuan|hy','������|yangjiang|yj','��Զ��|qingyuan|qy','��ݸ��|dongguan|dg','��ɽ��|zhongshan|zs','������|chaozhou|cz','������|jieyang|jy','�Ƹ���|yunfu|yf','������|nanning|nn','������|liuzhou|lz','������|guilin|gl','������|wuzhou|wz','������|beihai|bh','���Ǹ���|fangchenggang|fcg','������|qinzhou|qz','�����|guigang|gg','������|yulin|yl','��ɫ��|baise|bs','������|hezhou|hz','�ӳ���|hechi|hc','������|laibin|lb','������|chongzuo|cz','������|haikou|hk','������|sanya|sy','��ָɽ��|wuzhishan|wzs','����|qionghai|qh','������|danzhou|dz','�Ĳ���|wenchang|wc','������|wanning|wn','������|dongfang|df','������|dingan|da','�Ͳ���|tunchang|tc','������|chengmai|cm','�ٸ���|lingao|lg','��ɳ����������|bsnzzzx|bsnzzzx','��������������|cjlzzzx|cjlzzzx','�ֶ�����������|ldlzzzx|ldlzzzx','��ˮ����������|lingshui|ls','��ͤ��������������|btlzmzzzx|btlzmzzzx','������������������|qzlzmzzzx|qzlzmzzzx','��ɳȺ��|xishaqundao|xsqd','��ɳȺ��|nanshaqundao|nsqd','��ɳȺ���ĵ������亣��|zhongshaqundao|zsqd','�Թ���|zigong|zg','��֦����|panzhihua|pzh','������|luzhou|lz','������|deyang|dy','������|mianyang|my','��Ԫ��|guangyuan|gy','������|suining|sn','�ڽ���|neijiang|nj','��ɽ��|leshan|ls','�ϳ���|nanchong|nc','üɽ��|meishan|ms','�˱���|yibin|yb','�㰲��|guangan|ga','������|dazhou|dz','�Ű���|yaan|ya','������|bazhong|bz','������|ziyang|zy','���Ӳ���Ǽ��������|abzzqzzzz|abzzqzzzz','���β���������|gzzzzzz|gzzzzzz','��ɽ����������|lsyzzzz|lsyzzzz','������|guiyang|gy','����ˮ��|liupanshui|lps','������|zunyi|zy','��˳��|anshun|as','ͭ�ʵ���|tongren|tr','ǭ���ϲ���������������|qxnbyzmzzzz|qxnbyzmzzzz','�Ͻڵ���|bijie|bj','ǭ�������嶱��������|qdnmzdzzzz|qdnmzdzzzz','ǭ�ϲ���������������|qnbyzmzzzz|qnbyzmzzzz','������|kunming|km','������|qujing|qj','��Ϫ��|yuxi|yx','��ɽ��|baoshan|bs','��ͨ��|zhaotong|zt','������|lijiang|lj','˼é��|simao|sm','�ٲ���|lincang|lc','��������������|cxyzzzz|cxyzzzz','��ӹ���������������|hhhnzyzzzz|hhhnzyzzzz','��ɽ׳������������|wszzmzzzz|wszzmzzzz','��˫���ɴ���������|xsbndzzzz|xsbndzzzz','�������������|dlbzzzz|dlbzzzz','�º���徰����������|dhdzjpzzzz|dhdzjpzzzz','ŭ��������������|njlszzzz|njlszzzz','�������������|dqzzzzz|dqzzzzz','������|lasa|ls','��������|changdudiqu|cd','ɽ�ϵ���|shannandiqu|sndq','�տ������|rikazediqu|rkzdq','��������|naqudiqu|nqdq','�������|alidiqu|aldq','��֥����|linzhidiqu|lzdq','������|xian|xa','ͭ����|tongchuan|tc','������|baoji|bj','������|xianyang|xy','μ����|weinan|wn','�Ӱ���|yanan|ya','������|hanzhong|hz','������|yulin|yl','������|ankang|ak','������|shangluo|sl','������|lanzhou|lz','��������|jiayuguan|jyg','�����|jinchang|jc','������|baiyin|by','��ˮ��|tianshui|ts','������|wuwei|ww','��Ҵ��|zhangye|zy','ƽ����|pingliang|pl','��Ȫ��|jiuquan|jq','������|qingyang|qy','������|dingxi|dx','¤����|longnan|ln','���Ļ���������|lxhzzzz|lxhzzzz','���ϲ���������|gnzzzzz|gnzzzzz','������|xining|xn','��������|haidongdiqu|hddq','��������������|hbzzzzz|hbzzzzz','���ϲ���������|hnzzzzz|hnzzzzz','���ϲ���������|hnzzzzz|hnzzzzz','�������������|glzzzzz|hlzzzzz','��������������|yszzzzz|yszzzzz','�����ɹ������������|hxmgzzzzzz|hxmgzzzzzz','������|yinchuan|yc','ʯ��ɽ��|shizuishan|szs','������|wuzhong|wz','��ԭ��|guyuan|gy','������|zhongwei|zw','��³ľ����|wulumuqi|wlmq','����������|kelamayi|klmy','��³������|tulufandiqu|tlfdq','���ܵ���|hamidiqu|hmdq','��������������|cjhzzzz|cjhzzzz','���������ɹ�������|betlmgzzz|betlmgzzz','���������ɹ�������|byglmgzzz|byglmgzzz','�����յ���|akesudiqu|aksdq','�������տ¶�����������|kzlskekzzzz|kzlskekzzzz','��ʲ����|kashidiqu|ksdq','�������|hetian|ht','���������������|ylhskzzz|ylhskzzz','���ǵ���|tachengdiqu|tcdq','����̩����|aletaidiqu|altdq','ʯ������|shihezi|shz','��������|alaer|ale','ͼľ�����|tumushuke|tmsk','�������|wujiaqu|wjq','̨����|taibei|tb','������|gaoxiong|gx','��¡��|jilong|jl','̨����|taizhong|tz','̨����|tainan|tn','������|xinzhu|xz','������|jiayi|jy','̨����|taibeixian|tbx','������|yilanxian|ylx','��԰��|taoyuanxian|tyx','������|xinzhuxian|xzx','������|miaolixian|mlx','̨����|taizhongxian|tzx','�û���|zhanghuaxian|zhx','��Ͷ��|nantouxian|ntx','������|yunlinxian|ylx','������|jiayixian|jyx','̨����|tainanxian|tnx','������|gaoxiongxian|gxx','������|pingdongxian|pdx','�����|penghuxian|phx','̨����|taidongxian|tdx','������|hualianxian|hlx','������|zhongxiqu|zxq','����|dongqu|dq','��������|jiulongchengqu|jlcq','������|guantangqu|gtq','����|nanqu|nq','��ˮ����|shenshuibuqu|ssbq','�ƴ�����|huangdaxianqu|hdxq','������|wanzaiqu|wzq','�ͼ�����|youjianwangqu|yjwq','�뵺��|lidaoqu|ldq','������|kuiqingqu|kqq','����|beiqu|bq','������|xigongqu|xgq','ɳ����|shatianqu|stq','������|tunmenqu|tmq','������|dabuqu|dbq','������|quanwanqu|qwq','Ԫ����|yuanlangqu|ylq','����������|huadimatangqu|hdmtq','ʥ����������|shenganduonitangqu|sadntq','������|datangqu|dtq','��������|wangdetangqu|wdtq','��˳����|fengshuntangqu|fstq','��ģ����|jiamotangqu|jmtq','ʥ���ø�����|shengfangjigetangqu|sfjgtq'];


/* ������ʽ ɸѡ���ĳ�������ƴ��������ĸ */

Vcity.regEx = /^([\u4E00-\u9FA5\uf900-\ufa2d]+)\|(\w+)\|(\w)\w*$/i;
Vcity.regExChiese = /([\u4E00-\u9FA5\uf900-\ufa2d]+)/;

/* *
 * ��ʽ����������Ϊ����oCity������a-h,i-p,q-z,hot���ų��з��飺
 * {HOT:{hot:[]},ABCDEFGH:{a:[1,2,3],b:[1,2,3]},IJKLMNOP:{i:[1.2.3],j:[1,2,3]},QRSTUVWXYZ:{}}
 * */
(function () {
    var citys = Vcity.allCity, match, letter,
            regEx = Vcity.regEx,
            reg2 = /^[a-b]$/i, reg3 = /^[c-d]$/i, reg4 = /^[e-g]$/i,reg5 = /^[h]$/i,reg6 = /^[j]$/i,reg7 = /^[k-l]$/i,reg8 =  /^[m-p]$/i,reg9 =  /^[q-r]$/i,reg10 =  /^[s]$/i,reg11 =  /^[t]$/i,reg12 =  /^[w]$/i,reg13 =  /^[x]$/i,reg14 =  /^[y]$/i,reg15 =  /^[z]$/i;
    if (!Vcity.oCity) {
        Vcity.oCity = {hot:{},AB:{},CD:{},EFG:{},H:{},J:{},KL:{},MNP:{},QR:{},S:{},T:{},W:{},X:{},Y:{},Z:{}};
        //console.log(citys.length);
        for (var i = 0, n = citys.length; i < n; i++) {
            match = regEx.exec(citys[i]);
            letter = match[3].toUpperCase();
            if (reg2.test(letter)) {
                if (!Vcity.oCity.AB[letter]) Vcity.oCity.AB[letter] = [];
                Vcity.oCity.AB[letter].push(match[1]);
            } else if (reg3.test(letter)) {
                if (!Vcity.oCity.CD[letter]) Vcity.oCity.CD[letter] = [];
                Vcity.oCity.CD[letter].push(match[1]);
            } else if (reg4.test(letter)) {
                if (!Vcity.oCity.EFG[letter]) Vcity.oCity.EFG[letter] = [];
                Vcity.oCity.EFG[letter].push(match[1]);
            }else if (reg5.test(letter)) {
                if (!Vcity.oCity.H[letter]) Vcity.oCity.H[letter] = [];
                Vcity.oCity.H[letter].push(match[1]);
            }else if (reg6.test(letter)) {
                if (!Vcity.oCity.J[letter]) Vcity.oCity.J[letter] = [];
                Vcity.oCity.J[letter].push(match[1]);
            }else if (reg7.test(letter)) {
                if (!Vcity.oCity.KL[letter]) Vcity.oCity.KL[letter] = [];
                Vcity.oCity.KL[letter].push(match[1]);
            }else if (reg8.test(letter)) {
                if (!Vcity.oCity.MNP[letter]) Vcity.oCity.MNP[letter] = [];
                Vcity.oCity.MNP[letter].push(match[1]);
            }else if (reg9.test(letter)) {
                if (!Vcity.oCity.QR[letter]) Vcity.oCity.QR[letter] = [];
                Vcity.oCity.QR[letter].push(match[1]);
            }else if (reg10.test(letter)) {
                if (!Vcity.oCity.S[letter]) Vcity.oCity.S[letter] = [];
                Vcity.oCity.S[letter].push(match[1]);
            }else if (reg11.test(letter)) {
                if (!Vcity.oCity.T[letter]) Vcity.oCity.T[letter] = [];
                Vcity.oCity.T[letter].push(match[1]);
            }else if (reg12.test(letter)) {
                if (!Vcity.oCity.W[letter]) Vcity.oCity.W[letter] = [];
                Vcity.oCity.W[letter].push(match[1]);
            }else if (reg13.test(letter)) {
                if (!Vcity.oCity.X[letter]) Vcity.oCity.X[letter] = [];
                Vcity.oCity.X[letter].push(match[1]);
            }else if (reg14.test(letter)) {
                if (!Vcity.oCity.Y[letter]) Vcity.oCity.Y[letter] = [];
                Vcity.oCity.Y[letter].push(match[1]);
            }else if (reg15.test(letter)) {
                if (!Vcity.oCity.Z[letter]) Vcity.oCity.Z[letter] = [];
                Vcity.oCity.Z[letter].push(match[1]);
            }

            /* ���ų��� ǰ16�� */
            if(i<20){
                if(!Vcity.oCity.hot['hot']) Vcity.oCity.hot['hot'] = [];
                Vcity.oCity.hot['hot'].push(match[1]);
            }
        }
    }
})();


/* ����HTMLģ�� */
Vcity._template = [
    '<p class="tip">ֱ���������������(֧�ֺ���/ƴ��)</p>',
    '<ul>',
    '<li class="on">���ų���</li>',
    '<li>AB</li>',
    '<li>CD</li>',
    '<li>EFG</li>',
    '<li>H</li>',
    '<li>J</li>',
    '<li>KL</li>',
    '<li>MNP</li>',
    '<li>QR</li>',
    '<li>S</li>',
    '<li>T</li>',
    '<li>W</li>',
    '<li>X</li>',
    '<li>Y</li>',
    '<li>Z</li>',
    '</ul>'
];

/* *
 * ���пؼ����캯��
 * @CitySelector
 * */

Vcity.CitySelector = function () {
    this.initialize.apply(this, arguments);
};

Vcity.CitySelector.prototype = {

    constructor:Vcity.CitySelector,

    /* ��ʼ�� */

    initialize :function (options) {
        var input = options.input;
        this.input = Vcity._m.$('#'+ input);
        this.inputEvent();
    },

    /* *
        

    /* *
     * @createWarp
     * ��������BOX HTML ���
     * */

    createWarp:function(){
        var inputPos = Vcity._m.getPos(this.input);
        var div = this.rootDiv = document.createElement('div');
        var that = this;

        // ����DIV��ֹð��
        Vcity._m.on(this.rootDiv,'click',function(event){
            Vcity._m.stopPropagation(event);
        });

        // ���õ���ĵ����ص����ĳ���ѡ���
        Vcity._m.on(document, 'click', function (event) {
            event = Vcity._m.getEvent(event);
            var target = Vcity._m.getTarget(event);
            if(target == that.input) return false;
            //console.log(target.className);
            if (that.cityBox)Vcity._m.addClass('hide', that.cityBox);
            if (that.ul)Vcity._m.addClass('hide', that.ul);
            if(that.myIframe)Vcity._m.addClass('hide',that.myIframe);
        });
        div.className = 'citySelector';
        div.style.position = 'absolute';
        div.style.left = inputPos.left + 'px';
        div.style.top = inputPos.bottom + 5 + 'px';
        div.style.zIndex = 999999;

        // �ж��Ƿ�IE6�������IE6��Ҫ���iframe������סSELECT��
        var isIe = (document.all) ? true : false;
        var isIE6 = this.isIE6 = isIe && !window.XMLHttpRequest;
        if(isIE6){
            var myIframe = this.myIframe =  document.createElement('iframe');
            myIframe.frameborder = '0';
            myIframe.src = 'about:blank';
            myIframe.style.position = 'absolute';
            myIframe.style.zIndex = '-1';
            this.rootDiv.appendChild(this.myIframe);
        }

        var childdiv = this.cityBox = document.createElement('div');
        childdiv.className = 'cityBox';
        childdiv.id = 'cityBox';
        childdiv.innerHTML = Vcity._template.join('');
        var hotCity = this.hotCity =  document.createElement('div');
        hotCity.className = 'hotCity';
        childdiv.appendChild(hotCity);
        div.appendChild(childdiv);
        this.createHotCity();
    },

    /* *
     * @createHotCity
     * TAB����DIV��hot,a-h,i-p,q-z ����HTML���ɣ�DOM����
     * {HOT:{hot:[]},ABCDEFGH:{a:[1,2,3],b:[1,2,3]},IJKLMNOP:{},QRSTUVWXYZ:{}}
     **/

    createHotCity:function(){
        var odiv,odl,odt,odd,odda=[],str,key,ckey,sortKey,regEx = Vcity.regEx,
                oCity = Vcity.oCity;
        for(key in oCity){
            odiv = this[key] = document.createElement('div');
            // ������ȫ������hide
            odiv.className = key + ' ' + 'cityTab hide';
            sortKey=[];
            for(ckey in oCity[key]){
                sortKey.push(ckey);
                // ckey����ABCDEDG˳������
                sortKey.sort();
            }
            for(var j=0,k = sortKey.length;j<k;j++){
                odl = document.createElement('dl');
                odt = document.createElement('dt');
                odd = document.createElement('dd');
                odt.innerHTML = sortKey[j] == 'hot'?'&nbsp;':sortKey[j];
                odda = [];
                for(var i=0,n=oCity[key][sortKey[j]].length;i<n;i++){
                    str = '<a href="#">' + oCity[key][sortKey[j]][i] + '</a>';
                    odda.push(str);
                }
                odd.innerHTML = odda.join('');
                odl.appendChild(odt);
                odl.appendChild(odd);
                odiv.appendChild(odl);
            }

            // �Ƴ����ų��е�����CSS
            Vcity._m.removeClass('hide',this.hot);
            this.hotCity.appendChild(odiv);
        }
        document.body.appendChild(this.rootDiv);
        /* IE6 */
        this.changeIframe();

        this.tabChange();
        this.linkEvent();
    },

    /* *
     *  tab����ĸ˳���л�
     *  @ tabChange
     * */

    tabChange:function(){
        var lis = Vcity._m.$('li',this.cityBox);
        var divs = Vcity._m.$('div',this.hotCity);
        var that = this;
        for(var i=0,n=lis.length;i<n;i++){
            lis[i].index = i;
            lis[i].onclick = function(){
                for(var j=0;j<n;j++){
                    Vcity._m.removeClass('on',lis[j]);
                    Vcity._m.addClass('hide',divs[j]);
                }
                Vcity._m.addClass('on',this);
                Vcity._m.removeClass('hide',divs[this.index]);
                /* IE6 �ı�TAB��ʱ�� �ı�Iframe ��С*/
                that.changeIframe();
            };
        }
    },

    /* *
     * ����LINK�¼�
     *  @linkEvent
     * */

    linkEvent:function(){
        var links = Vcity._m.$('a',this.hotCity);
        var that = this;
        for(var i=0,n=links.length;i<n;i++){
            links[i].onclick = function(){
                that.input.value = this.innerHTML;
                Vcity._m.addClass('hide',that.cityBox);
                /* �����������ʱ������myIframe */
                Vcity._m.addClass('hide',that.myIframe);
            }
        }
    },

    /* *
     * INPUT����������¼�
     * @inputEvent
     * */

    inputEvent:function(){
        var that = this;
        Vcity._m.on(this.input,'click',function(event){
            event = event || window.event;
            if(!that.cityBox){
                that.createWarp();
            }else if(!!that.cityBox && Vcity._m.hasClass('hide',that.cityBox)){
                // slideul �����ڻ��� slideul���ڵ��������ص�ʱ�� ���߲��ܹ���
                if(!that.ul || (that.ul && Vcity._m.hasClass('hide',that.ul))){
                    Vcity._m.removeClass('hide',that.cityBox);

                    /* IE6 �Ƴ�iframe ��hide ��ʽ */
                    //alert('click');
                    Vcity._m.removeClass('hide',that.myIframe);
                    that.changeIframe();
                }
            }
        });
        // Vcity._m.on(this.input,'focus',function(){
        //     that.input.select();
        //     if(that.input.value == '������') that.input.value = '';
        // });
        Vcity._m.on(this.input,'blur',function(){
            // if(that.input.value == '') that.input.value = '������';
            
            var value = Vcity._m.trim(that.input.value);
            if(value != ''){
                var reg = new RegExp("^" + value + "|\\|" + value, 'gi');
                var flag=0;
                for (var i = 0, n = Vcity.allCity.length; i < n; i++) {
                    if (reg.test(Vcity.allCity[i])) {
                        flag++;
                    }
                }
                if(flag==0){
                    that.input.value= '';
                }else{
                    var lis = Vcity._m.$('li',that.ul);
                    if(typeof lis == 'object' && lis['length'] > 0){
                        var li = lis[0];
                        var bs = li.children;
                        if(bs && bs['length'] > 1){
                            that.input.value = bs[0].innerHTML;
                        }
                    }else{
                        that.input.value = '';
                    }
                }
            }

        });
        Vcity._m.on(this.input,'keyup',function(event){
            event = event || window.event;
            var keycode = event.keyCode;
            Vcity._m.addClass('hide',that.cityBox);
            that.createUl();

            /* �Ƴ�iframe ��hide ��ʽ */
            Vcity._m.removeClass('hide',that.myIframe);

            // �����˵���ʾ��ʱ��׽�����¼�
            if(that.ul && !Vcity._m.hasClass('hide',that.ul) && !that.isEmpty){
                that.KeyboardEvent(event,keycode);
            }
        });
    },

    /* *
     * ��������ѡ���б�
     * @ createUl
     * */

    createUl:function () {
        //console.log('createUL');
        var str;
        var value = Vcity._m.trim(this.input.value);
        // ��value�����ڿյ�ʱ��ִ��
        if (value !== '') {
            var reg = new RegExp("^" + value + "|\\|" + value, 'gi');
            // �˴��������������뷨Ҳ����onpropertychange
            var searchResult = [];
            for (var i = 0, n = Vcity.allCity.length; i < n; i++) {
                if (reg.test(Vcity.allCity[i])) {
                    var match = Vcity.regEx.exec(Vcity.allCity[i]);
                    if (searchResult.length !== 0) {
                        str = '<li><b class="cityname">' + match[1] + '</b><b class="cityspell">' + match[2] + '</b></li>';
                    } else {
                        str = '<li class="on"><b class="cityname">' + match[1] + '</b><b class="cityspell">' + match[2] + '</b></li>';
                    }
                    searchResult.push(str);
                }
            }
            this.isEmpty = false;
            // �����������Ϊ��
            if (searchResult.length == 0) {
                this.isEmpty = true;
                str = '<li class="empty">�Բ���û���ҵ� "<em>' + value + '</em>"</li>';
                searchResult.push(str);
            }
            // ���slideul�����������ul
            if (!this.ul) {
                var ul = this.ul = document.createElement('ul');
                ul.className = 'cityslide mCustomScrollbar';
                this.rootDiv && this.rootDiv.appendChild(ul);
                // ��¼���������������
                this.count = 0;
            } else if (this.ul && Vcity._m.hasClass('hide', this.ul)) {
                this.count = 0;
                Vcity._m.removeClass('hide', this.ul);
            }
            this.ul.innerHTML = searchResult.join('');

            /* IE6 */
            this.changeIframe();

            // ��Li�¼�
            this.liEvent();
        }else{
            Vcity._m.addClass('hide',this.ul);
            Vcity._m.removeClass('hide',this.cityBox);

            Vcity._m.removeClass('hide',this.myIframe);

            this.changeIframe();
        }
    },

    /* IE6�ĸı�����SELECT �� IFRAME�ߴ��С */
    changeIframe:function(){
        if(!this.isIE6)return;
        this.myIframe.style.width = this.rootDiv.offsetWidth + 'px';
        this.myIframe.style.height = this.rootDiv.offsetHeight + 'px';
    },

    /* *
     * �ض������¼����ϡ��¡�Enter��
     * @ KeyboardEvent
     * */

    KeyboardEvent:function(event,keycode){
        var lis = Vcity._m.$('li',this.ul);
        var len = lis.length;
        switch(keycode){
            case 40: //���¼�ͷ��
                this.count++;
                if(this.count > len-1) this.count = 0;
                for(var i=0;i<len;i++){
                    Vcity._m.removeClass('on',lis[i]);
                }
                Vcity._m.addClass('on',lis[this.count]);
                break;
            case 38: //���ϼ�ͷ��
                this.count--;
                if(this.count<0) this.count = len-1;
                for(i=0;i<len;i++){
                    Vcity._m.removeClass('on',lis[i]);
                }
                Vcity._m.addClass('on',lis[this.count]);
                break;
            case 13: // enter��
                this.input.value = Vcity.regExChiese.exec(lis[this.count].innerHTML)[0];
                Vcity._m.addClass('hide',this.ul);
                Vcity._m.addClass('hide',this.ul);
                /* IE6 */
                Vcity._m.addClass('hide',this.myIframe);
                break;
            default:
                break;
        }
    },

    /* *
     * �����б��li�¼�
     * @ liEvent
     * */

    liEvent:function(){
        var that = this;
        var lis = Vcity._m.$('li',this.ul);
        for(var i = 0,n = lis.length;i < n;i++){
            Vcity._m.on(lis[i],'click',function(event){ 
                event = Vcity._m.getEvent(event);
                var target = Vcity._m.getTarget(event);
                that.input.value = Vcity.regExChiese.exec(target.innerHTML)[0];
                Vcity._m.addClass('hide',that.ul);
                /* IE6 �����˵�����¼� */
                Vcity._m.addClass('hide',that.myIframe);
            });
            Vcity._m.on(lis[i],'mouseover',function(event){
                event = Vcity._m.getEvent(event);
                var target = Vcity._m.getTarget(event);
                Vcity._m.addClass('on',target);
            });
            Vcity._m.on(lis[i],'mouseout',function(event){
                event = Vcity._m.getEvent(event);
                var target = Vcity._m.getTarget(event);
                Vcity._m.removeClass('on',target);
            })
        }
    }
};