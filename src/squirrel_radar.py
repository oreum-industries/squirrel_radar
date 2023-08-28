# Copyright 2023 Oreum Industries
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# squirrel_radar.py
"""Create Squirrel Radar"""

import re
import string
from pathlib import Path

import pandas as pd
import plotly.express as px


def _clean_fname(s: str = None) -> str:
    """Reduced version of oreum_core snakey_lowercaser"""
    rx_to_underscore = re.compile(r'[-/]')
    rx_punct = re.compile('[{}]'.format(re.escape(string.punctuation)))
    s0 = rx_to_underscore.sub('_', str(s))
    s1 = rx_punct.sub('', s0)
    return '_'.join(s1.lower().split())


def create_radar(scores: list = [3, 3, 3, 3, 3, 3], project_name: str = None) -> str:
    """Create radar plot
    NOTE:
    + Score list must be length 6, each score in range [0, 5], starting with Org Maturity
    + Suggest project_name e.g. 'Company, Month Year'"""
    assert len(scores) == 6, "Scores must be length 6"
    assert (min(scores) >= 0) & (max(scores) <= 5), "Scores must be in range [0, 5]"
    score_names = [
        '<b>Org Maturity</b><br><i>(Key Metric: Seniority)</i>',
        '<b>Management & Leadership</b><br><i>(Key Metric: Trust)</i>',
        '<b>Product Fit</b><br><i>(Key Metric: Sales)</i>',
        '<b>Feedback</b><br><i>(Key Metric: Cycle Time)</i>',
        '<b>Code & Architecture</b><br><i>(Key Metric: Testing)</i>',
        '<b>Operations</b><br><i>(Key Metric: Monitoring)</i>',
    ]
    scoresd = {k: v for k, v in zip(score_names, scores)}
    title = ' - '.join(filter(None, ["Squirrel's Radar Assessment", project_name]))

    df = pd.DataFrame.from_dict(scoresd, orient="index", columns=['r']).reset_index()
    f = px.line_polar(
        df,
        theta='index',
        r='r',
        line_close=True,
        range_r=[0, 5],
        start_angle=120,
        width=720,
        height=540,
        markers=True,
        title=title,
        render_mode='svg',
    )
    f.update_traces(fill='toself')
    f.add_annotation(
        text="© 2023",
        xref="paper",
        yref="paper",
        x=1,
        xanchor="right",
        y=0.1,
        yanchor="top",
        showarrow=False,
        font=dict(color='#888', size=8),
    )
    fqn = Path("plots", f"{_clean_fname(title)}.png")
    f.write_image(fqn, engine="kaleido", format='png')
    return f"Output to {fqn}"


if __name__ == "__main__":
    create_radar()
