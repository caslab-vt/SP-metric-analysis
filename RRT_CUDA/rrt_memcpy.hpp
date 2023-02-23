#ifndef RRT_INCLUDE_GUARD_HPP
#define RRT_INCLUDE_GUARD_HPP

#include <cmath>
#include <vector>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>

//#include <cuda.h>
//#include <cuda_runtime.h>
using namespace std;
using namespace std::chrono;
struct vertex;


struct Circle
{
  float x;
  float y;
  float r;

  Circle() : x(0.0), y(0.0), r(0.0) {}
};

struct Polygon
{
  float x1;
  float y1;
  float x2;	
  float y2;

  Polygon() : x1(0.0),y1(0.0),x2(0.0),y2(0.0) {}
	
};
Polygon* polygons_dev;
Polygon* polygons_;
float* v_new_near_host;
int* flag_host;
float* new_vertex_cuda;
float* distances_cuda;
vertex* vertex_host_ptr; //list where we keep track of all the new vertexes

float* distances_host;

cudaEvent_t stopEvent;

// /// \brief edges connecting nodes
// struct Edge
// {
//     vertex *v = nullptr;
// };


/// \brief nodes in the graph
struct vertex
{
    int id;
    float x;
    float y;
    //int rank; //used to alculate the distance of the vertex from the starting location
    // std::vector<Edge> Edges; // adjacent vertices
    std::vector<int> adjacent_vertices;

    vertex() : id(-1), x(0.0), y(0.0) {}
    vertex(float x, float y): id(-1), x(x), y(y) {}
};
vertex* vertex_cuda_ptr;
float*  new_vertex_host;

/// \brief Distance between vertices
/// \param p1 - point 1
/// \param p2 - point 2
float distance(const float *p1, const float *p2);

float cross(const float *p0, const float *p1, const float *p2);

int sign(float value);

/// \brief Finds the closest point on a line (p2 to p1) to p3
/// \param p1 - point 1 connected to point 2
/// \param p2 - point 2 connected to point 1
/// \param p3 - center point of circle
/// \returns - distance between circle and the closest point on the line
float closestPointDistance(const float *p1, const float *p2, const float *p3);

int num_obstacles;
int rand_num;
cudaStream_t stream[2];
float* v_new_near_dev;

#define MAX_ITER (10240*4)
//uncomment the following line to write the data to the file
//#define WR2F  

#ifdef WR2F
ofstream myfile;
ofstream myfile1;
#endif


/// \brief RRT search in continous space
class RRT
{
public:
  /// \brief Constructs RRT search
  RRT(float *start, float *goal, int rando);

  /// \brief RRT from start to goal with no obstacles
  /// \returns true if goal reached
  bool explore();

  /// \brief RRT from start to goal with with obstacles
  /// \returns true if goal reached
  bool exploreObstacles();

  /// \brief RRT from start to goal with with obstacles
  	bool exploreCuda();

  /// \brief fills arrays with the obstacle data
  /// \param h_x - host array with circle's x position
  /// \param h_y - host array with circle's y position
  /// \param h_r - host array with circle's radius
 // void circleData(float *h_x, float *h_y, float *h_r);

  /// \brief fills arrays with the obstacle data
  /// \param h_c - vector oc centers and radius
//  void circleDatafloat3(float3 *h_c);

  /// \bried Generate random circles
  /// \param num_cirles - number of circles
  /// \param r_min - min radius
  /// \param r_max - max radius
  void randomCircles(int num_cirles, float r_min, float r_max);
 double randomObstacles(int num_obstacle, float x_min, float x_max, float y_min, float y_max);

  /// \brief Traverse graph to get path
  /// \param path - the vector of vertex from start to goal
 // void traverseGraph(std::vector<vertex> &path) const;

 /// \brief print the entire graph
//  void printGraph() const;

  /// \brief write obsctacles and graph to csvs for visualization
//  void visualizeGraph() const;

private:
  /// \brief Adds new nodes to graph
  /// \param x - x position
  /// \param y - y position
  void addVertex(vertex &v);

  /// \brief Adds Edge btw two nodes
  /// \param v_near- parent
  /// \param v_new - child
  void addEdge(const vertex &v_near, const vertex &v_new);

  /// \brief Creates a new vertex by moveing a delta away from
  ///        the random point selected in the world
  /// \param v_near - nearest vertex to random point
  /// \param q_rand - random point
  /// \return true if the new vertex is created
  /// v_new[out] - newly created vertex
  bool newConfiguration(vertex &v_new,
                        const vertex &v_near,
                        const float *q_rand) const;

  /// \brief Find the nearest vertex in graph
  /// \param q_rand - random point
  /// v[out] - nearest vertex
  void nearestVertex(vertex &v, float *q_rand) const;
  void nearestVertex_cuda(vertex &v, float *q_rand) const;

  /// \brief Creates a random point in the world
  /// q_rand[out] x and y coordinates of point
  void randomConfig(float *q_rand) const;

  /// \brief - Finds parent vertex in graph
  /// \param v - the child vertex
  /// \returns - index of parent
  int findParent(const vertex &v) const;

  /// \brief - Checks if there is a straightline path between node and goal
  /// \param vnew - newly added vertex
  /// \param goal - goal location
  /// \returns true if straightline path to goal false if obstructed
  bool win_check(const vertex &v_new, const float *goal);
  bool win_check_cuda(const vertex &v_new,const float *goal);

  /// \brief Test whether the new vertex would collide with an obstacle
  ///     or if the path to the new vertex intersects with an obstacle
  /// \param v_new - potential new vertex to add to graph
  /// \param v_near - closest vertex in graph to v_new
  /// \returns true if collision between edge and an obstacle
  bool collision_check(const vertex &v_new, const vertex &v_near);

  bool PolygonCollisionCheck(const vertex &v_new, const vertex &v_near);	
  bool polygon_collision_check_cuda(const vertex &v_new,const vertex &v_near,int goal_check);

  float *start_;                                 // start config
  float *goal_;                                  // goal config
  float delta_;                                  // distance to place new node
  float epsilon_;                                // away from goal and obstacles
  float xmin_, xmax_, ymin_, ymax_;             // world bounds
  float resolution_;                              // grid granularity 
  int max_iter_;                                  // max iterations
  int vertex_count_;                              // counts which vertex
  int obstacles_count_;				  // counts the number of obstacles
  //std::vector<vertex> vertices_;                   // all nodes in graph
  //std::vector<Circle> circles_;
};
cudaError_t status;
__global__ void polygon_collision_check_dev(Polygon* polygons_ ,float* p0,int offset);
#define TIME_IT(ROUTINE_NAME__, LOOPS__, ACTION__)\
{\
    printf("    Timing '%s' started\n", ROUTINE_NAME__);\
    struct timeval tv;\
    struct timezone tz;\
    const clock_t startTime = clock();\
    gettimeofday(&tv, &tz); long GTODStartTime =  tv.tv_sec * 1000 + tv.tv_usec / 1000 ;\
    for (int loops = 0; loops < (LOOPS__); ++loops)\
    {\
        ACTION__;\
    }\
    gettimeofday(&tv, &tz); long GTODEndTime =  tv.tv_sec * 1000 + tv.tv_usec / 1000 ;\
    const clock_t endTime = clock();\
    const clock_t elapsedTime = endTime - startTime;\
    const float timeInSeconds = (elapsedTime/(float)CLOCKS_PER_SEC);\
    printf("        GetTimeOfDay Time (for %d iterations) = %g\n", LOOPS__, (float)(GTODEndTime - GTODStartTime) / 1000. );\
    printf("        Clock Time        (for %d iterations) = %g\n", LOOPS__, timeInSeconds );\
    printf("    Timing '%s' ended\n", ROUTINE_NAME__);\
}







#endif
