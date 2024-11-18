-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
    map_builder = MAP_BUILDER,
    trajectory_builder = TRAJECTORY_BUILDER,
    map_frame = "map",--地图坐标系
    tracking_frame = "gyro_link",--实体选imu，仿真选base_footprint
    published_frame = "base_footprint",--机器人底盘坐标系
    odom_frame = "odom",-- cartographer发布的odom坐标系名
    provide_odom_frame = true, --是否使用cartographer提供的坐标系
    publish_frame_projected_to_2d = true, --是否使用纯2d姿态（去掉俯仰，偏航） 
    use_pose_extrapolator = false,--是否使用姿势外推器
    use_odometry = true, --是否使用机器人odom
    use_nav_sat = false, --是否使用gps
    use_landmarks = false,--是否使用landmark数据
    num_laser_scans = 1,--激光雷达数量
    num_multi_echo_laser_scans = 0,--要订阅的多回波激光扫描主题的数量
    num_subdivisions_per_laser_scan = 1, --将激光雷达的数据拆分成几次发出来，对于普通的激光雷达，此处为1
    num_point_clouds = 0,--点云数量
    lookup_transform_timeout_sec = 0.2,
    submap_publish_period_sec = 0.3,
    pose_publish_period_sec = 5e-3,
    trajectory_publish_period_sec = 30e-3,
    rangefinder_sampling_ratio = 1.,--测距仪信息的固定比率采样
    odometry_sampling_ratio = 1.,
    fixed_frame_pose_sampling_ratio = 1.,
    imu_sampling_ratio = 1.,
    landmarks_sampling_ratio = 1.,
    }
  
    MAP_BUILDER.use_trajectory_builder_2d = true--3d激光还是2d激光
    

    TRAJECTORY_BUILDER_2D.submaps.num_range_data = 45
    TRAJECTORY_BUILDER_2D.min_range = 0.24
    TRAJECTORY_BUILDER_2D.max_range = 10.
    TRAJECTORY_BUILDER_2D.missing_data_ray_length = 1.
    TRAJECTORY_BUILDER_2D.use_imu_data = true
    --重力常数
    TRAJECTORY_BUILDER_2D.imu_gravity_time_constant = 9.8883
    
    TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching = true--这个参数配置的是否使用 实时的闭环检测方法 来进行前端的扫描匹配。如果这项为false，则扫描匹配使用的是通过前一帧位置的先验，将当前scan与之前做对比，使用 高斯牛顿法 迭代 求解最小二乘问题 求得当前scan的坐标变换。如果这项为true，则使用闭环检测的方法，将当前scan在一定的搜索范围内搜索，范围为设定的平移距离及角度大小，然后在将scan插入到匹配的最优位置处。这种方式建图的效果非常好，即使建图有漂移也能够修正回去，但是这个方法的计算复杂度非常高，非常耗cpu。
    TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window = 0.1
    --TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.angular_search_window = math.rad(45.)
    TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.translation_delta_cost_weight = 10.
    TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.rotation_delta_cost_weight = 1e-1
  
    --扫描匹配器可以在不影响分数的情况下自由地前后移动匹配项。我们希望通过使扫描匹配器支付更多费用来偏离这种情况，
    --从而对这种情况进行惩罚。控制它的两个参数是TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight和
    --rotation_weight。越高，将结果从先前移开，换句话说，就越昂贵：扫描匹配必须在要接受的另一个位置产生更高的分数。
    TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 2e2
    TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 4e2
  
    POSE_GRAPH.optimization_problem.huber_scale = 1e2
    
    return options