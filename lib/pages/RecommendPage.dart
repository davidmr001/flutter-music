import 'package:flutter_music/baseImport.dart';
import 'package:flutter_music/entitesImport.dart';
import 'package:flutter_music/widgets/RecommendSwiper.dart';
import 'package:flutter_music/widgets/HotMusicItem.dart';

/// 推荐页
class RecommendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // with AutomaticKeepAliveClientMixin 保存页面状态

  List<HotMusicItemEntity> hotMusicItemEntities = [];

  MyState() {
    _getHotMusicList();
  }

  Future<Null> _handleRefresh() async {
    await _getHotMusicList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
          itemCount: hotMusicItemEntities.length + 2,
          itemBuilder: (context, index) {
            // 轮播图
            if (index == 0) {
              return RecommendSwiper();
            }
            // 头“热门歌单推荐”
            else if (index == 1) {
              return Container(
                height: 65.0,
                alignment: Alignment.center,
                child: Text('热门歌单推荐',
                    style: TextStyle(color: COLOR_YELLOW, fontSize: 14.0)),
              );
            }
            // 热门歌单列表
            else {
              return HotMusicItem(hotMusicItemEntities[index - 2]);
            }
          }),
    );
  }

  _getHotMusicList() async {
    Response response = await Api.getHotMusicList();
    if (response == null) {
      MyToast.show('热门推荐歌单请求出错');
    } else {
      HotMusicResp resp = HotMusicResp.fromJson(json.decode(response.data));
      if (Api.isOk(resp.code)) {
        setState(() {
          hotMusicItemEntities = resp.data.list;
        });
      }
    }
  }
}
