library home;

import 'package:digital_three/Providers/home_provider.dart';
import 'package:digital_three/models/movie_model_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Home extends ConsumerWidget {
  static const ROUTE_NAME = "/home";
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double windowHeight = MediaQuery.of(context).size.height;
    // final moviePvd = ref.watch(movieProvider);
    final moviePvd = ref.watch(movieProvider1);
    Widget child;

    child = Consumer(builder: (context, ref, child) {
      return moviePvd.when(
        data: (movieModelNew) => buildMovieList(movieModelNew),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Error: $error'),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    height: windowHeight * 0.2,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: CloseButton(),
                          ),
                          Row(
                            children: [
                              Text(
                                'Company:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 2),
                              Text('Digital Edge 360'),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                    '9B,Everest House, Kankaria estate, Kolkata- 700031'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.info,
              ),
            ),
          )
        ],
      ),
      body: child,
    );
  }

  Widget buildMovieList(MovieModelNew movieModel) {
    return ListView.builder(
      itemCount: movieModel.result.length,
      itemBuilder: (context, index) {
        double windowHeight = MediaQuery.of(context).size.height;
        double windowWidth = MediaQuery.of(context).size.width;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: windowHeight * 0.3,
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.arrow_drop_up,
                              size: 40,
                            ),
                            Text(
                              movieModel.result
                                  .elementAt(index)
                                  .totalVoted
                                  .toString(),
                              style: const TextStyle(fontSize: 25),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 40,
                            ),
                            const Text(
                              'Votes',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: windowHeight * 0.2,
                          width: windowWidth * 0.25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(movieModel.result
                                    .elementAt(index)
                                    .poster
                                    .toString()),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                movieModel.result
                                    .elementAt(index)
                                    .title
                                    .toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Release Date: ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: DateFormat.yMMMd().format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            movieModel.result
                                                    .elementAt(index)
                                                    .releasedDate *
                                                1000),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Genre: ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: movieModel.result
                                          .elementAt(index)
                                          .genre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Page Views: ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "${movieModel.result.elementAt(index).pageViews}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Director: ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: movieModel.result
                                          .elementAt(index)
                                          .director
                                          .toString()
                                          .replaceAll('[', "")
                                          .replaceAll(']', ''),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Stars: ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          " ${movieModel.result.elementAt(index).stars.toString().replaceAll('[', "").replaceAll(']', '')}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Container(
                      height: windowHeight * 0.05,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('Watch Trailer'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
