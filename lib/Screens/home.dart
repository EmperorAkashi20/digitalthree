library home;

import 'package:digital_three/Providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/moview_model.dart';

class Home extends ConsumerWidget {
  static const ROUTE_NAME = "/home";
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double windowHeight = MediaQuery.of(context).size.height;
    final moviePvd = ref.watch(movieProvider);
    Widget child;

    child = Consumer(builder: (context, ref, child) {
      return moviePvd.when(
        data: (movieModel) => buildMovieList(movieModel),
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

  Widget buildMovieList(MovieModel movieModel) {
    return ListView.builder(
      itemCount: movieModel.results.length,
      itemBuilder: (context, index) {
        double windowHeight = MediaQuery.of(context).size.height;
        double windowWidth = MediaQuery.of(context).size.width;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Card(
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
                              size: 70,
                            ),
                            Text(
                              movieModel.results
                                  .elementAt(index)
                                  .voteCount
                                  .toString(),
                              style: const TextStyle(fontSize: 30),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 70,
                            ),
                            const Text(
                              'Votes',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: windowHeight * 0.2,
                          width: windowWidth * 0.25,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?cs=srgb&dl=pexels-anjana-c-674010.jpg&fm=jpg"),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              movieModel.results
                                  .elementAt(index)
                                  .originalTitle
                                  .toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Release Date: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: movieModel.results
                                                .elementAt(index)
                                                .releaseDate !=
                                            null
                                        ? DateFormat.yMd().format(
                                            DateTime.parse(
                                              movieModel.results
                                                  .elementAt(index)
                                                  .releaseDate
                                                  .toString(),
                                            ),
                                          )
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Popularity: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        "${movieModel.results.elementAt(index).popularity}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Id: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${movieModel.results.elementAt(index).id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Lang: ${movieModel.results.elementAt(index).originalLanguage.toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${movieModel.results.elementAt(index).voteAverage} Vote Avg\nVoted by ${movieModel.results.elementAt(index).voteCount} People',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
